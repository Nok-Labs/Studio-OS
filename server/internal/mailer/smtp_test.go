package mailer

import (
	"bufio"
	"context"
	"errors"
	"io"
	"net"
	"strings"
	"sync"
	"testing"
)

// smtpRecord is what the fake server captured from one conversation.
type smtpRecord struct {
	from    string
	rcpt    []string
	message string
}

// fakeSMTP is a minimal SMTP server: enough of the protocol to accept a message
// and record what arrived.
//
// It deliberately does not advertise STARTTLS, so the client takes the
// cleartext path. That is permitted only because PlainAuth exempts loopback
// addresses, which is why the listener binds 127.0.0.1 rather than a routable
// interface — the exemption is not something this test wants to generalize.
type fakeSMTP struct {
	mu   sync.Mutex
	rec  smtpRecord
	errs []error
}

// startFakeSMTP serves on an ephemeral loopback port and returns the mailer
// configured to reach it, plus a snapshot function for what was received.
func startFakeSMTP(t *testing.T) (*SMTPMailer, func() smtpRecord) {
	t.Helper()

	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("listen: %v", err)
	}
	t.Cleanup(func() { ln.Close() })

	s := &fakeSMTP{}
	go s.accept(ln)

	addr := ln.Addr().String()
	host, port, err := net.SplitHostPort(addr)
	if err != nil {
		t.Fatalf("SplitHostPort(%q): %v", addr, err)
	}

	return NewSMTPMailer(host, port, "sender@example.com", "app-password",
			"sender@example.com", "https://app.example.com"),
		func() smtpRecord {
			s.mu.Lock()
			defer s.mu.Unlock()
			return s.rec
		}
}

func (s *fakeSMTP) accept(ln net.Listener) {
	for {
		conn, err := ln.Accept()
		if err != nil {
			return // listener closed by cleanup
		}
		go s.handle(conn)
	}
}

func (s *fakeSMTP) fail(err error) {
	s.mu.Lock()
	s.errs = append(s.errs, err)
	s.mu.Unlock()
}

func (s *fakeSMTP) handle(conn net.Conn) {
	defer conn.Close()

	r := bufio.NewReader(conn)
	reply := func(line string) { io.WriteString(conn, line+"\r\n") }
	reply("220 fake.test ESMTP")

	for {
		line, err := r.ReadString('\n')
		if err != nil {
			return
		}
		line = strings.TrimRight(line, "\r\n")
		verb := strings.ToUpper(strings.SplitN(line, " ", 2)[0])

		switch verb {
		case "EHLO", "HELO":
			// Advertise AUTH PLAIN and nothing else. Advertising STARTTLS
			// would require a certificate; omitting it exercises the branch
			// where the client skips the upgrade.
			io.WriteString(conn, "250-fake.test\r\n250 AUTH PLAIN\r\n")
		case "AUTH":
			reply("235 2.7.0 Authentication successful")
		case "MAIL":
			s.mu.Lock()
			s.rec.from = angleAddr(line)
			s.mu.Unlock()
			reply("250 OK")
		case "RCPT":
			s.mu.Lock()
			s.rec.rcpt = append(s.rec.rcpt, angleAddr(line))
			s.mu.Unlock()
			reply("250 OK")
		case "DATA":
			reply("354 End data with <CR><LF>.<CR><LF>")
			msg, err := readDotStuffed(r)
			if err != nil {
				s.fail(err)
				return
			}
			s.mu.Lock()
			s.rec.message = msg
			s.mu.Unlock()
			reply("250 OK")
		case "QUIT":
			reply("221 Bye")
			return
		default:
			reply("250 OK")
		}
	}
}

// angleAddr pulls the address out of a protocol line, from the angle brackets
// when present and bare otherwise.
func angleAddr(line string) string {
	if i := strings.IndexByte(line, '<'); i >= 0 {
		if j := strings.IndexByte(line[i:], '>'); j >= 0 {
			return line[i+1 : i+j]
		}
	}
	if parts := strings.SplitN(line, ":", 2); len(parts) == 2 {
		return strings.TrimSpace(parts[1])
	}
	return ""
}

// readDotStuffed collects message lines until the terminating dot, dropping the
// dot-stuffing escape.
func readDotStuffed(r *bufio.Reader) (string, error) {
	var sb strings.Builder
	for {
		line, err := r.ReadString('\n')
		if err != nil {
			return "", err
		}
		trimmed := strings.TrimRight(line, "\r\n")
		if trimmed == "." {
			return strings.TrimSuffix(sb.String(), "\r\n"), nil
		}
		if strings.HasPrefix(trimmed, "..") {
			trimmed = trimmed[1:]
		}
		sb.WriteString(trimmed + "\r\n")
	}
}

func TestSMTPMailerDeliversAnOTPEmail(t *testing.T) {
	m, received := startFakeSMTP(t)

	if err := m.SendOTP(context.Background(), "dev@example.com", "481920"); err != nil {
		t.Fatalf("SendOTP() = %v, want nil", err)
	}

	rec := received()
	if rec.from != "sender@example.com" {
		t.Errorf("MAIL FROM = %q, want sender@example.com", rec.from)
	}
	if len(rec.rcpt) != 1 || rec.rcpt[0] != "dev@example.com" {
		t.Errorf("RCPT TO = %v, want [dev@example.com]", rec.rcpt)
	}

	// The exact contract the frontend relies on: the code, HTML, and headers
	// that make a mail client render it as HTML rather than show raw markup.
	for _, want := range []string{
		"From: sender@example.com",
		"To: dev@example.com",
		"Subject: Your Verification Code",
		"Content-Type: text/html; charset=UTF-8",
		"481920",
	} {
		if !strings.Contains(rec.message, want) {
			t.Errorf("message missing %q\n---\n%s", want, rec.message)
		}
	}
}

func TestSMTPMailerSendInviteEmbedsTheConfiguredAppBaseURL(t *testing.T) {
	m, received := startFakeSMTP(t)

	if err := m.SendInvite(context.Background(), "dev@example.com", "tok-abc"); err != nil {
		t.Fatalf("SendInvite() = %v, want nil", err)
	}

	msg := received().message
	want := "https://app.example.com/accept-invite#token=tok-abc"
	if !strings.Contains(msg, want) {
		t.Errorf("message missing invite link %q\n---\n%s", want, msg)
	}
	// The fragment must survive into the href, otherwise the token is dropped
	// and the acceptance page has nothing to redeem.
	if !strings.Contains(msg, `href="https://app.example.com/accept-invite#token=tok-abc"`) {
		t.Errorf("invite URL not in an href attribute\n---\n%s", msg)
	}
}

func TestSMTPMailerDeliversAPasswordResetCode(t *testing.T) {
	m, received := startFakeSMTP(t)

	if err := m.SendPasswordReset(context.Background(), "dev@example.com", "771122"); err != nil {
		t.Fatalf("SendPasswordReset() = %v, want nil", err)
	}

	if !strings.Contains(received().message, "771122") {
		t.Errorf("message missing the reset code")
	}
}

func TestSMTPMailerSendsNothingWhenTheContextIsAlreadyCancelled(t *testing.T) {
	m, received := startFakeSMTP(t)

	ctx, cancel := context.WithCancel(context.Background())
	cancel()

	err := m.SendOTP(ctx, "dev@example.com", "123456")
	if err == nil {
		t.Fatal("SendOTP() = nil, want an error for a cancelled context")
	}
	if !errors.Is(err, context.Canceled) {
		t.Errorf("SendOTP() = %v, want it to wrap context.Canceled", err)
	}
	if rec := received(); rec.message != "" {
		t.Errorf("cancelled request still delivered a message:\n%s", rec.message)
	}
}

func TestBuildMessageTerminatesEveryHeaderWithCRLF(t *testing.T) {
	// A bare LF in a header is a protocol violation: some servers reject it
	// outright, and others fold the rest of the message into that header.
	msg := buildMessage("a@example.com", "b@example.com", "Hi", "<p>line one</p>")

	if strings.Contains(msg, "\r\r") {
		t.Errorf("message contains a doubled carriage return:\n%q", msg)
	}
	for _, line := range strings.Split(msg, "\r\n") {
		if strings.Contains(line, "\n") {
			t.Errorf("bare LF survived in line %q", line)
		}
	}
}

func TestBuildMessageNormalizesPreexistingCRLF(t *testing.T) {
	msg := buildMessage("a@example.com", "b@example.com", "Hi", "one\r\ntwo")

	if strings.Contains(msg, "\r\r\n") {
		t.Errorf("existing CRLF was doubled:\n%q", msg)
	}
	if !strings.Contains(msg, "one\r\ntwo") {
		t.Errorf("expected a single CRLF between lines, got:\n%q", msg)
	}
}

func TestSMTPMailerDefaultsToPort587WhenUnset(t *testing.T) {
	// 587 is the submission port that negotiates STARTTLS. Leaving it unset
	// has to mean that, not an empty port string — net.JoinHostPort with an
	// empty port would dial "host:" and fail on every send.
	m := NewSMTPMailer("smtp.gmail.com", "", "u", "p", "f@example.com", "https://x.example")
	if m.port != "587" {
		t.Errorf("port = %q, want 587", m.port)
	}
}
