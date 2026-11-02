package token

import (
	"encoding/hex"
	"regexp"
	"testing"
)

func TestGenerateRandomTokenReturnsRawAndMatchingHash(t *testing.T) {
	raw, hash, err := GenerateRandomToken()
	if err != nil {
		t.Fatalf("GenerateRandomToken returned error: %v", err)
	}

	if len(raw) != 64 {
		t.Fatalf("raw token length = %d, want 64 hex chars", len(raw))
	}
	if _, err := hex.DecodeString(raw); err != nil {
		t.Fatalf("raw token is not hex: %v", err)
	}
	if hash != HashToken(raw) {
		t.Fatalf("hash %q does not match HashToken(raw)", hash)
	}
	if len(hash) != 64 {
		t.Fatalf("hash length = %d, want 64 hex chars", len(hash))
	}
}

func TestGenerateRandomTokenIsUnique(t *testing.T) {
	seen := make(map[string]struct{}, 100)
	for i := 0; i < 100; i++ {
		raw, _, err := GenerateRandomToken()
		if err != nil {
			t.Fatalf("GenerateRandomToken returned error: %v", err)
		}
		if _, exists := seen[raw]; exists {
			t.Fatalf("duplicate token generated: %s", raw)
		}
		seen[raw] = struct{}{}
	}
}

func TestHashTokenIsDeterministic(t *testing.T) {
	if HashToken("abc") != HashToken("abc") {
		t.Fatal("HashToken is not deterministic")
	}
	if HashToken("abc") == HashToken("abd") {
		t.Fatal("HashToken collided for distinct inputs")
	}
}

func TestGenerateOTPIsSixDigits(t *testing.T) {
	sixDigits := regexp.MustCompile(`^[0-9]{6}$`)
	for i := 0; i < 100; i++ {
		code, err := GenerateOTP()
		if err != nil {
			t.Fatalf("GenerateOTP returned error: %v", err)
		}
		if !sixDigits.MatchString(code) {
			t.Fatalf("GenerateOTP() = %q, want six digits including leading zeros", code)
		}
	}
}
