# Studio OS — Requirements Specification (v2, Go stack)

**Owner:** Nok Labs (lead: Niyi)
**Backend:** Go · Echo v5 · sqlc · pgx · goose · PostgreSQL
**Frontend:** Flutter (web + mobile) · Dart · Riverpod · go_router · shadcn UI
**Status:** Draft v2. Replaces the Serverpod-based v1.

Requirement IDs (e.g. `PRJ-03`) are stable so you can reference them in issues and commits. Priority: **P0** = MVP, **P1** = v1.1, **P2** = later.

## Review tracker

| Section                       | Status                                                                    |
| ----------------------------- | ------------------------------------------------------------------------- |
| 1 Purpose and vision          | Reviewed                                                                  |
| 2 Users and roles             | Reviewed                                                                  |
| 3 Architecture                | Rewritten for Go (this version)                                           |
| 4 Domain model                | Reviewed in plain terms; three questions still open (see §14)             |
| 5.8 Billing and payments      | **Pending review**                                                        |
| 5.9 Revenue split and payouts | **Pending review. Percentages are placeholders, confirm before building** |
| Everything else               | Not yet reviewed                                                          |

---

## 1. Purpose and vision

Studio OS is the single system a small software studio uses to run its whole delivery lifecycle: win a client, scope and price a fixed-price MVP, deliver it in milestones, collect client feedback, get paid, and split revenue among the team.

It replaces the WhatsApp threads, Google Sheets, Notion pages and Trello boards with one source of truth that has two faces:

1. **Internal dashboard** for the studio team.
2. **Client portal** for clients, with a deliberately narrow view of their own projects.

Because Nok Labs builds and uses it, it is also the studio's showcase.

### Success criteria

- A new client project goes from intake to kickoff in under 15 minutes of staff time.
- A client can see status, approve milestones and leave feedback without messaging a team member on WhatsApp.
- Every naira/dollar received is traceable to a milestone and split automatically.
- No client can ever see another client's data (zero tolerance).

### Non-goals (for now)

- Not a general-purpose SaaS for other agencies (single studio; see §12 for the cheap hedge).
- Not a full accounting system (exports for the accountant only).
- Not a code host or CI tool (links to GitHub only).
- Not a chat app (comments and notifications only).

---

## 2. Users and roles

| Role                     | Who                 | Scope                                                                                   |
| ------------------------ | ------------------- | --------------------------------------------------------------------------------------- |
| **Admin**                | Admin               | Everything, including settings, finance, split rules, user management                   |
| **Project Manager (pm)** |                     | All projects, tasks, milestones, client comms, create invoices. Cannot edit split rules |
| **Contributor**          | D                   | Only projects they are assigned to; own tasks, time logs, deliverables                  |
| **Client Owner**         | The person who pays | Own organization's projects, approvals, invoices, feedback                              |
| **Client Member**        | Client's staff      | Same as Client Owner minus invoices and approvals (configurable)                        |
| **Guest**                | One-off stakeholder | Read-only on one project, expiring link (P2)                                            |

### Permission rules (enforced on the server, never only in the app)

- `AUTH-01` Each user has one **role** (`admin`, `pm`, `contributor`, `client`) stored on the user row. A reusable Echo middleware, `RequireRole(...)`, is the first gate on every route. This replaces the starter's `is_admin` / `is_punter` / `is_suspended` booleans.
- `AUTH-02` A role is not enough. Every route that touches a project also passes through one shared `authz` package that answers: "is this user a member of this project, or of the client org that owns it?" No permission logic is written directly inside handlers.
- `AUTH-03` Client-facing routes return separate **client-safe response types** (for example `MilestoneClientView`), never the internal models. A field that isn't in the type can't leak.
- `AUTH-04` Asking for another client's resource returns **404, not 403**, so IDs can't be probed. Every denial writes an audit row.

---

## 3. Architecture

### 3.1 Stack

| Layer                  | Choice                                                                                                     | Notes                                                                                                                                                                                                      |
| ---------------------- | ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Language / server      | Go, **Echo v5**                                                                                            | Echo v5 is the current major line. Handlers use the `*echo.Context` struct-pointer form, and recent v5 releases appear to need Go 1.25+. Pin the exact version and read the release notes before upgrading |
| Database               | PostgreSQL via **pgx** (pool)                                                                              |                                                                                                                                                                                                            |
| Queries                | **sqlc**                                                                                                   | You write SQL, it generates typed Go. No ORM                                                                                                                                                               |
| Migrations             | **goose**                                                                                                  | Versioned SQL files, committed, never edited after merge                                                                                                                                                   |
| API contract           | **swaggo** annotations on handlers generate the Swagger/OpenAPI spec                                       | See 3.4 for the decision and the Dart client                                                                                                                                                               |
| Auth                   | In-house: JWT access token (15 min) plus rotating refresh tokens, bcrypt                                   | Built on your existing starter. See §5.1 for the gaps to close                                                                                                                                             |
| Background jobs        | **River** (Postgres-backed queue)                                                                          | Reminders, overdue checks, emails, reconciliation, webhook retries                                                                                                                                         |
| Realtime               | Server-Sent Events (SSE) from Echo                                                                         | One-way notifications. WebSockets only if two-way is ever needed                                                                                                                                           |
| Files                  | S3-compatible object storage, presigned URLs, behind a `Storage` interface                                 | Provider still open (see §14). Serverpod's built-in database storage no longer exists                                                                                                                      |
| Email / payments / PDF | Behind `Mailer`, `PaymentProvider`, `PDFRenderer` interfaces                                               | Resend for email (already in the starter); Paystack first                                                                                                                                                  |
| Client app             | Flutter (web + mobile), **Riverpod** for state, **go_router** for navigation, **shadcn UI** for components | One codebase, role-based routes                                                                                                                                                                            |
| Cache                  | None in the MVP                                                                                            | Add Redis only if measured need appears                                                                                                                                                                    |

### 3.2 Repository layout

```
studio-os/
  server/
    cmd/api/                  # main.go, wiring.go
    internal/
      config/
      httpserver/             # Echo setup, middleware, route mounting
      auth/                   # primitives: JWT, hashing, tokens, RequireAuth
        handler/ service/ repository/ model/
      authz/                  # THE place permission checks live
      <domain>/               # projects, milestones, tasks, feedback, billing, split ...
        handler/ service/ repository/ model/
      db/
        queries/*.sql         # sqlc inputs
        generated/            # sqlc output (committed)
      jobs/                   # River workers
      payments/ mailer/ storage/ pdf/    # provider interfaces + implementations
      apitypes/  response/    # shared response helpers
    migrations/               # goose
    docs/                     # swaggo output
  app/                        # Flutter app
    lib/
      core/                   # theme, router, api client, storage, errors
      features/<domain>/      # data/ (repos), domain/ (models), presentation/ (screens, providers)
  packages/api_client/        # generated Dart client (never hand-edited)
```

It is one deployable **modular monolith**: a single Go binary containing the API and the River workers.

### 3.3 Backend rules

- `ARCH-01` **Layers:** handler → service → repository. Handlers only decode, authorize, call a service and encode. Services hold all business rules and depend on repository **interfaces**, so they can be tested with fakes (the pattern your starter already uses).
- `ARCH-02` **DTOs are separate from database structs.** sqlc structs never cross the HTTP boundary.
- `ARCH-03` **Migrations only.** No manual database edits, ever.
- `ARCH-04` **Transactions for anything that matters.** A small transaction helper wraps several repository calls into one all-or-nothing unit. Approvals, invoice numbering, payments, splits and payouts use it. The **audit row and any River jobs are written inside the same transaction**, so you never email about something that rolled back.
- `ARCH-05` **Money is `BIGINT` minor units** (kobo/cents) plus a currency code. No floats. One shared money package.
- `ARCH-06` **UTC in storage,** shown in `Africa/Lagos` by default.
- `ARCH-07` **Configuration through environment variables** loaded once in `config.Load`. Secrets are never committed. Three environments: dev, staging, prod.
- `ARCH-08` **One authorization package** (`authz`), used by every project-scoped route.
- `ARCH-09` **Client-safe response types** for every client-facing route.
- `ARCH-10` **Every external provider sits behind an interface** so a swap is a small change.
- `ARCH-11` **IDs are UUIDs** (v7 if your Postgres version supports it, otherwise v4). Never sequential integers in URLs.
- `ARCH-12` **Errors:** services return typed domain errors; the handler maps them to status codes in one place (your starter's pattern).
- `ARCH-13` **Logging:** structured JSON via `slog`, with a request ID on every line.
- `ARCH-14` **Echo client IP:** configure Echo's IP extractor to match the deployment (direct, behind a reverse proxy, or behind Cloudflare). Rate limiting depends on it being right.

### 3.4 API contract and Dart client

- `API-01` Handlers carry **swaggo** annotations; the spec is generated with `swag init` and committed.
- `API-02` A CI step regenerates the spec and **fails the build if the committed spec is out of date**. This is the guard against comments drifting from real behavior.
- `API-03` The Dart client in `packages/api_client` is **generated from the spec** (with a generator such as `openapi-generator` or `swagger_parser`) and never edited by hand.
- `API-04` Open decision: swaggo's stable release emits **Swagger 2.0**, while its newer v2 line targets OpenAPI 3.x. Pick the stable one unless you need a 3.x feature, and confirm your chosen Dart generator supports it before committing.
- `API-05` Every route documents its success and error responses, because the Dart client's error handling is generated from them.

### 3.5 Flutter app rules

- `APP-01` **Feature-first folders.** Each feature has `data`, `domain` and `presentation`.
- `APP-02` **Riverpod** for state: `AsyncNotifier` / `Notifier` providers for server state, plain providers for dependencies (API client, token store). Screens never call the API directly.
- `APP-03` **go_router** with one route table. A **redirect guard** reads the signed-in user's role and sends them to the right shell: dashboard for staff, portal for clients. A client can never reach a dashboard route even by typing the URL.
- `APP-04` **shadcn UI** components wrapped in a small app-level design system (buttons, inputs, tables, dialogs, badges, toasts) so screens never use raw package widgets directly.
- `APP-05` **Auth handling:** access token in memory, refresh token in secure storage on mobile (and a suitable web-safe store on web). An HTTP interceptor refreshes on 401 **once**, queues concurrent requests during the refresh, and signs the user out if the refresh fails.
- `APP-06` **Responsive layouts:** dashboard is desktop-first, portal is mobile-first. One codebase, breakpoint-aware layouts.
- `APP-07` **Errors and loading:** every list and detail screen has loading, empty and error states. Generated client errors map to friendly messages.
- `APP-08` **Theming:** light and dark, one token set, WCAG AA contrast.
- `APP-09` **Testing:** widget tests with provider overrides and a fake repository; a few end-to-end flows (login, approve milestone, submit feedback).
- `APP-10` **Web specifics:** deep links work for every portal page (a client opens an email link and lands on the right milestone after login).

---

## 4. Domain model

Every table has `id`, `created_at`, `updated_at`. `deleted_at` (soft delete) is marked where used.

### 4.1 Identity and organization

- **users:** email, password hash, first/last name, `role`, `is_active` (replaces `is_suspended`), email verified at, timezone, avatar.
- **refresh_tokens:** (existing) token hash, expiry, revoked at. Add device info and `last_used_at`.
- **otp_codes:** (existing) email, code hash, purpose (signup, password reset, login 2FA later), attempts, expiry.
- **staff_profiles:** title, skills, internal hourly cost, split profile.
- **client_orgs:** name, industry, billing email, country, default currency, internal notes, status (lead / active / past).
- **client_members:** user, client org, role (owner / member), `can_approve`, `can_view_invoices`.
- **invitations:** email, role, client org (optional), token hash, expires at, accepted at, revoked at.

### 4.2 Delivery

- **projects:** client org, name, slug, summary, type (foundry MVP / retainer / studio-equity / internal), status, currency, fixed price, dates, repo / staging / prod URLs, health, `deleted_at`.
- **project_members:** project, user, project role (lead / dev / designer / pm / qa), optional split override.
- **milestones:** project, title, description, order, due date, amount, status, approved by / at.
- **tasks:** project, milestone (optional), title, markdown description, status, priority, assignee, estimate, due date, labels, parent task (optional), `visible_to_client`.
- **time_entries:** task/project, user, minutes, date, note, billable. *(P1)*
- **deliverables:** milestone, title, type (build / design / doc / link), file or URL, version.

### 4.3 Communication and feedback

- **comments:** author, body, visibility (internal / client), edited at. Attached to exactly one of feedback, milestone or task through **separate nullable foreign keys** with a `CHECK` that exactly one is set. (A generic type-plus-id pair can't be enforced by the database.)
- **feedback_items:** project, milestone (optional), submitter, type (bug / change request / question / praise), title, body, severity, status, linked task, `is_out_of_scope`, resolution note.
- **notifications:** user, type, JSON payload, read at.
- **file_assets:** project, uploader, name, MIME type, size, storage key, visibility.

### 4.4 Money *(pending review)*

- **quotes:** client org, project, version, status, line items, total, valid until.
- **invoices:** project, milestone, gap-free number, status, currency, subtotal, tax, total, due date, PDF.
- **payments:** invoice, provider, provider reference (unique), amount, currency, status, paid at, raw webhook body.
- **expenses:** project, category, amount, paid by, receipt, reimbursable.
- **split_rules:** versioned; lines of (recipient, percent) plus reserve percent; effective from.
- **payouts:** payment, recipient (user or reserve), amount, status (accrued / approved / paid), method, reference.

### 4.5 System

- **audit_log:** actor, action, entity type/id, before/after JSON, IP, timestamp. Append-only.
- **settings:** studio-level key/value configuration.
- **webhook_events:** provider, event ID (unique), payload, processed at.

### Database rules

- `DB-01` Status columns use Postgres `CHECK` constraints (or enum types) so bad values are rejected by the database, and are mirrored in the API spec.
- `DB-02` Index every foreign key and every column used to filter or sort a list.
- `DB-03` Financial and audit tables are never updated in place and never soft-deleted. Corrections are new rows.
- `DB-04` Deleting a user, client or project never cascades to financial records.
- `DB-05` Email is stored lowercased and trimmed, with a unique index on the normalized value.

---

## 5. Functional requirements

### 5.1 Authentication and accounts

Built on the existing starter. Items marked **[gap]** are missing or wrong in the starter today.

- `AUTH-10` (P0) **Invite-only registration [gap].** The public signup route is removed or disabled. Staff are invited by Admin; client users by Admin or PM. Invitation links are single-use, expire in 7 days, can be revoked, and are stored hashed.
- `AUTH-11` (P0) Email and password login with email verification by OTP (exists).
- `AUTH-12` (P0) **Password reset [gap].** OTP or link flow using the reserved purpose in `otp_codes`.
- `AUTH-13` (P0) **Suspension is enforced [gap].** Login and refresh reject inactive users; deactivating a user revokes all their refresh tokens immediately, and access-token checks also look at the active flag so a deactivated user is cut off within seconds, not 15 minutes.
- `AUTH-14` (P0) **Refresh rotation hardened [gap].** Rotating a token is a single atomic statement (revoke only if not already revoked). Presenting an **already-used** refresh token is treated as theft and revokes all of that user's tokens.
- `AUTH-15` (P0) **Sign out everywhere [gap].** An endpoint that revokes every refresh token for the current user (the query already exists).
- `AUTH-16` (P0) **Emails are normalized [gap]** on every entry point (signup, login, resend, invite, reset).
- `AUTH-17` (P0) **No timing leak on login [gap].** An unknown email still performs a dummy password comparison so response time doesn't reveal which emails exist.
- `AUTH-18` (P0) **OTP attempts are counted atomically [gap]** in a single SQL statement, so concurrent guesses can't exceed the limit.
- `AUTH-19` (P0) **Rate limits on every auth route [gap],** not only login: verify, resend, refresh, reset and invite acceptance. Add a per-email login lockout in addition to the per-IP limit.
- `AUTH-20` (P0) **Request hardening [gap]:** maximum request body size, server read/write/header timeouts, password length capped at 72 bytes (bcrypt's limit), and bcrypt cost raised to at least 12.
- `AUTH-21` (P0) A signup race on the unique email index returns 409, not 500.
- `AUTH-22` (P1) Google sign-in for staff.
- `AUTH-23` (P1) Optional 2FA for Admin and PM (the schema already reserves the purpose).
- `AUTH-24` (P0) Refresh tokens are listed per device so a user can revoke one session.
- `AUTH-25` (P0) Before launch, an independent review pass of the whole auth package.

### 5.2 Leads and intake (CRM-lite)

- `CRM-01` (P0) Public **intake form** (name, email, company, budget range, description, timeline, referral source) behind a rate limit and captcha.
- `CRM-02` (P0) A submission creates a client org in `lead` status and notifies Admin/PM.
- `CRM-03` (P0) Lead pipeline board: New → Contacted → Scoping → Quote sent → Won → Lost.
- `CRM-04` (P1) Log calls and meetings with next-action dates; overdue follow-ups show on the dashboard.
- `CRM-05` (P1) One-click convert a won lead into a project.
- `CRM-06` (P2) Lost-reason tracking and win rate.

### 5.3 Scoping and quotes

- `QUO-01` (P0) Build a quote from line items (feature, description, hours, price), with either computed or fixed totals.
- `QUO-02` (P0) Quotes are versioned; sending freezes an immutable snapshot.
- `QUO-03` (P0) Client views, accepts or declines in the portal; acceptance records who, when and IP.
- `QUO-04` (P0) Quote templates for the foundry model (for example, 4 milestones with a 40/30/30 payment schedule).
- `QUO-05` (P1) A payment schedule on the quote becomes milestone amounts and draft invoices on acceptance.
- `QUO-06` (P1) Internal margin view (Admin only).
- `QUO-07` (P1) Branded PDF export.
- `QUO-08` (P2) Change-request quotes linked to the original project.

### 5.4 Projects

- `PRJ-01` (P0) Create, edit, archive projects; soft delete only.
- `PRJ-02` (P0) Overview page: status, health, next milestone, deadlines, team, recent activity, open feedback, budget used vs price.
- `PRJ-03` (P0) Assign and remove members with project roles. Contributors see only their projects.
- `PRJ-04` (P0) Health set manually by PM with a reason; history kept.
- `PRJ-05` (P1) Project templates.
- `PRJ-06` (P0) Links panel: repo, staging, production, design file, docs.
- `PRJ-07` (P1) Kickoff checklist gating draft → active.
- `PRJ-08` (P1) Handover checklist on delivery.
- `PRJ-09` (P2) Warranty/maintenance window tracking.

### 5.5 Milestones and tasks

- `MIL-01` (P0) CRUD milestones with order, due date and payment amount.
- `MIL-02` (P0) Status is a **state machine**: planned → in progress → submitted → approved / rejected → paid. Illegal transitions are rejected by the server.
- `MIL-03` (P0) PM submits a milestone with deliverables and notes; client is notified.
- `MIL-04` (P0) Client approves or rejects; a comment is required on rejection. Approval creates or unlocks the milestone invoice.
- `MIL-05` (P1) Optional auto-approval after N days of silence (off by default).
- `MIL-06` (P0) Milestone progress = weighted completion of its tasks.
- `TSK-01` (P0) Kanban board per project plus a list view.
- `TSK-02` (P0) Task fields: title, markdown description, assignee, priority, estimate, due date, labels, milestone, attachments.
- `TSK-03` (P0) `visible_to_client` flag, default false. The portal shows only flagged tasks, read-only.
- `TSK-04` (P1) Subtasks and simple dependencies.
- `TSK-05` (P1) "My work" view across projects.
- `TSK-06` (P1) Time tracking and weekly timesheet.
- `TSK-07` (P2) GitHub PR/issue links, later webhook status sync.

### 5.6 Client feedback pipeline

- `FBK-01` (P0) Clients submit feedback (bug / change request / question / praise) with title, description, severity, optional milestone and screenshots.
- `FBK-02` (P1) Shareable "give feedback" link for staging builds, pre-filled with project and build.
- `FBK-03` (P0) Every item has a status and a visible timeline.
- `FBK-04` (P0) PM triages: accept (creates a linked task), reject with reason, mark duplicate, or flag out of scope.
- `FBK-05` (P0) Out-of-scope items must be turned into a change request or explicitly absorbed with a reason.
- `FBK-06` (P0) Threaded comments with internal-only and client-visible visibility.
- `FBK-07` (P0) Client is notified (in-app and email) on every status change and staff reply.
- `FBK-08` (P1) When the linked task is done, the item moves to "resolved, awaiting client confirmation"; the client confirms or reopens.
- `FBK-09` (P1) Revision counter per milestone with a warning as the contractual limit approaches.
- `FBK-10` (P2) Feedback analytics.

### 5.7 Client portal

- `POR-01` (P0) Simple navigation: Projects, Milestones, Feedback, Invoices, Files, Account.
- `POR-02` (P0) Only client-visible data (AUTH-03). Never hours, costs, rates or splits.
- `POR-03` (P0) Project timeline of milestones with status and dates.
- `POR-04` (P0) Approve or reject milestones, accept quotes, pay invoices, submit feedback.
- `POR-05` (P0) Deliverables and files with version history.
- `POR-06` (P1) Weekly progress digest email.
- `POR-07` (P1) White-label logo and colors in portal and emails.
- `POR-08` (P2) Client-side decision log.

### 5.8 Billing and payments *(pending review)*

- `BIL-01` (P0) Create invoices manually or automatically from milestone approval or a payment schedule.
- `BIL-02` (P0) Gap-free sequential invoice numbers per year, generated **inside a transaction**.
- `BIL-03` (P0) Multi-currency (NGN and USD at minimum); one currency per invoice.
- `BIL-04` (P0) Online payment through the provider; the app opens checkout and a **webhook** confirms payment.
- `BIL-05` (P0) The webhook route is an ordinary Echo route with three hard rules: it reads the **raw request body** before any parsing so the signature can be verified, it dedupes on the provider's event ID, and it records every event in `webhook_events`.
- `BIL-06` (P0) Manual payment recording (bank transfer) with proof upload.
- `BIL-07` (P0) Invoice status derives from payments; partial payments and overpayments are handled and flagged.
- `BIL-08` (P0) A daily River job flags overdue invoices and sends reminders at configurable intervals.
- `BIL-09` (P1) PDF invoices with branding and payment link.
- `BIL-10` (P1) Configurable tax/VAT (default off).
- `BIL-11` (P1) Credit notes and voiding, never deletion.
- `BIL-12` (P2) Recurring invoices.
- `BIL-13` (P2) Client statement export.

### 5.9 Revenue split and payouts *(pending review; percentages are placeholders)*

Current placeholder rule: lead ??, design ??, second Flutter dev ??, PM ??, agency reserve ??. 

- `REV-01` (P0) Split rules are versioned. A payment uses the rule effective on its received date, and the rule version is stored on the payouts.
- `REV-02` (P0) On confirmed payment, compute payouts per recipient plus the reserve in integer minor units with **deterministic rounding** (the remainder goes to the reserve).
- `REV-03` (P0) Per-project overrides require Admin approval and an audit entry.
- `REV-04` (P0) A payout ledger per person (accrued, approved, paid). Each person sees only their own.
- `REV-05` (P0) Admin approves payouts and marks them paid with method and reference.
- `REV-06` (P1) Deductions before the split: provider fees and reimbursable expenses (order of operations documented and visible).
- `REV-07` (P1) Reserve ledger.
- `REV-08` (P1) Monthly statement per team member.
- `REV-09` (P2) USD to NGN conversion policy with rate source and date recorded.
- `REV-10` (P0) **Invariant:** for every payment, payouts plus reserve equal the net distributable amount. Enforced by a test and a nightly River reconciliation job.

### 5.10 Internal dashboard

- `DSH-01` (P0) Admin/PM home: active projects and health, milestones due in 14 days, unpaid and overdue invoices, feedback awaiting triage, new leads.
- `DSH-02` (P0) Contributor home: my tasks, my deadlines, my payouts.
- `DSH-03` (P1) Financial overview (Admin).
- `DSH-04` (P1) Team utilization.
- `DSH-05` (P1) Project profitability.
- `DSH-06` (P2) Pipeline forecast.

### 5.11 Files and documents

- `FIL-01` (P0) The server issues a **short-lived presigned upload link**; the app uploads directly to storage; the server records the file after an ownership and permission check. Downloads are presigned links issued only after authorization.
- `FIL-02` (P0) Size limit (default 25 MB) and MIME allowlist.
- `FIL-03` (P1) Deliverable versioning with changelog.
- `FIL-04` (P1) Contract/SOW storage with signed/unsigned state.
- `FIL-05` (P2) Virus scanning hook.

### 5.12 Notifications

- `NOT-01` (P0) In-app notifications delivered over **SSE**, with an unread badge. The app reconnects automatically and catches up on missed items on reconnect.
- `NOT-02` (P0) Email for invitations, quote sent, milestone submitted and decided, feedback changes, invoice sent / overdue / paid, task assigned. Sent through River jobs so a mail failure retries instead of failing a request.
- `NOT-03` (P1) Per-user preferences (clients cannot disable billing emails).
- `NOT-04` (P1) Daily/weekly digest for staff.
- `NOT-05` (P1) Mobile push (FCM).
- `NOT-06` (P2) WhatsApp Business notifications.

### 5.13 Search, audit, admin

- `SYS-01` (P1) Global search across projects, tasks, feedback and files, permission-filtered.
- `SYS-02` (P0) Audit log viewer (Admin).
- `SYS-03` (P0) Settings: studio profile, branding, default currency, payment terms, default split rule, notification templates.
- `SYS-04` (P1) Per-project data export.
- `SYS-05` (P1) Soft delete with a 30-day restore window.

---

## 6. Key workflows

### 6.1 Lead to kickoff

1. Intake form creates a lead and notifies the PM.
2. PM builds a quote from a template and sends it.
3. Client accepts in the portal; the system creates the project, milestones and upfront invoice.
4. Deposit is confirmed by webhook; once the kickoff checklist is ticked the project goes Active.

### 6.2 Milestone delivery

1. Tasks are completed; PM marks the milestone **Submitted** with deliverables.
2. Client approves or rejects with a comment.
3. Approved: invoice is issued or unlocked; payment triggers payout accrual.
4. Rejected: comments become tasks, the milestone returns to In progress, the revision counter increments.

### 6.3 Feedback

1. Client submits; PM triages within one business day.
2. In scope becomes a task; out of scope becomes a change-request quote or a decline.
3. Task done: client confirms or reopens.

### 6.4 Payment and split *(pending review)*

1. Provider webhook arrives: raw body read, signature verified, event deduplicated.
2. In one transaction: record the payment, deduct fees, apply the effective split rule, write payouts and the reserve entry, write the audit row, enqueue notifications.
3. Admin approves and pays out; each person sees an updated ledger.

---

## 7. Non-functional requirements

### 7.1 Security

- `SEC-01` TLS everywhere. Secrets only in environment variables or a secret manager.
- `SEC-02` Authorization on every route (AUTH-01 to 04). An **automated cross-client test** attempts to read and write another client's resources on every client-facing route.
- `SEC-03` Validate all input (length, format, enums). Sanitize markdown before rendering in Flutter web.
- `SEC-04` Files only through presigned, short-lived links after authorization.
- `SEC-05` Payment webhooks are signature-verified; never trust a "payment success" from the app.
- `SEC-06` Password hashing with bcrypt at cost 12 or higher; no custom crypto.
- `SEC-07` Collect only the personal data needed; client contact data visible only to staff on that project.
- `SEC-08` Monthly dependency review (`govulncheck` for Go, `dart pub outdated` for Flutter) in CI.
- `SEC-09` Nigeria Data Protection Act: documented consent, access, export and deletion procedures.
- `SEC-10` CORS locked to the real app origins in staging and production (no wildcard).
- `SEC-11` The JWT secret is at least 32 random bytes, rotatable, and different per environment.

### 7.2 Performance and scale

- Sized for 50 concurrent users, around 200 projects, 100k tasks, 1M audit rows.
- p95 API latency under 300 ms for reads and 600 ms for writes (excluding external providers).
- Dashboard loads in under 2 s on typical Nigerian 4G; lists are paginated; payloads are small.
- Index every filtered or sorted column; check slow queries with `EXPLAIN` before launch.

### 7.3 Reliability

- Daily Postgres backups, 30-day retention, and a **tested** restore drill each quarter.
- Money-affecting operations are transactional and idempotent. River jobs are safe to retry.
- If email or the payment provider is down, work queues and retries with backoff; the UI shows state instead of failing silently.
- Graceful shutdown (already in the starter) so deploys don't drop in-flight requests.
- Uptime target 99.5% on a single instance.

### 7.4 Connectivity

- `NET-01` Mobile caches last-seen projects and tasks for read-only offline viewing.
- `NET-02` Uploads retry cleanly.
- `NET-03` Optimistic UI for task moves and comments, with rollback on failure.

### 7.5 Observability

- Structured logs with request IDs, Sentry for errors (server and app), uptime pings, alerts on failed webhooks, failed jobs and reconciliation mismatches, and a system-health page for Admin.

### 7.6 Usability and accessibility

- Mobile-first portal, light and dark themes, WCAG AA contrast, respect for text scaling, plain-language wording for non-technical clients.

### 7.7 Testing and delivery

- Unit tests for services with fake repositories (money math, state machines, authorization, split).
- A small set of integration tests against a real throwaway Postgres for money and migration code.
- Coverage targets: 90% on billing, split and authorization; 60% elsewhere.
- CI: `gofmt` and `go vet` → `sqlc generate` (fail if output differs) → `swag init` (fail if spec differs) → tests → build → deploy to staging on merge to main.
- Flutter CI: analyze → widget tests → build web.

---

## 8. Integrations

| Integration                   | Priority | Notes                                                             |
| ----------------------------- | -------- | ----------------------------------------------------------------- |
| Paystack                      | P0       | NGN checkout, webhooks, refunds; behind `PaymentProvider`         |
| Flutterwave or Stripe         | P1       | USD and international clients                                     |
| Resend (email)                | P0       | Already in the starter; templates for every notification in §5.12 |
| Object storage (R2, B2 or S3) | P0       | Private bucket, presigned URLs; provider open (§14)               |
| Google OAuth                  | P1       | Staff sign-in                                                     |
| GitHub                        | P1       | PR/issue links, later webhooks                                    |
| FCM                           | P1       | Push notifications                                                |
| Google Calendar               | P2       | Milestone deadlines                                               |
| WhatsApp Business API         | P2       | Client notifications                                              |
| CSV export                    | P1       | For the accountant                                                |

---

## 9. Data rules and invariants

1. A milestone cannot be **paid** unless a payment covering its invoice exists.
2. A milestone can only be approved by a client with `can_approve` (or Admin acting on their behalf, with an audit note).
3. Invoice numbers are unique and gap-free within a year.
4. A provider payment reference is recorded only once.
5. Payouts plus reserve equal the net distributable amount for every payment (REV-10).
6. Split rules are never edited in place; changes create a new version.
7. Client-visible comments are append-only after the client has read them; internal comments can be edited with history.
8. Deleting a user, client or project never cascades to financial records.
9. Currency is fixed per project and its invoices.
10. Audit rows are append-only.
11. A deactivated user cannot authenticate and holds no live refresh tokens.

---

## 10. MVP scope and phasing

**Phase 1: Foundation (weeks 1 to 3).** Harden the starter's auth (AUTH-10 to 25), roles, invitations, the `authz` package, transaction helper, audit log, settings, CI checks, Flutter shell with go_router role guards and shadcn design system.

**Phase 2: Delivery core (weeks 4 to 7).** Projects, members, milestones with state machine, tasks and kanban, comments, file uploads, River jobs, notifications (in-app and email), internal dashboard basics.

**Phase 3: Client portal and feedback (weeks 8 to 10).** Portal screens, milestone approval, feedback pipeline with triage and out-of-scope handling.

**Phase 4: Money (weeks 11 to 14).** Quotes, invoices, Paystack and webhooks, manual payments, overdue jobs, split engine, payout ledger, reconciliation job. *(Scope depends on the pending billing and split review.)*

**Phase 5: Hardening (weeks 15 to 16).** Security review, cross-client test suite, backup and restore drill, performance pass, dogfood on one live project, bug bash.

The timeline assumes one primary developer plus part-time help. Building auth on the starter shortens Phase 1 compared with v1.

**Post-MVP (P1/P2):** CRM depth, templates, time tracking and profitability, digests, push, GitHub sync, white-label, recurring billing, e-signature, WhatsApp.

---

## 11. Acceptance criteria (samples for the riskiest areas)

**Client isolation**

- Given Client A's user, when requesting any resource ID that belongs to Client B, the response is 404 and an audit entry is written.

**Auth**

- Given a deactivated user, login fails, refresh fails, and their existing access token stops working within the configured window.
- Given a refresh token that was already rotated, presenting it again revokes all of that user's tokens.
- Given an unknown email and a known email with a wrong password, responses are identical in body and similar in timing.
- Given 20 concurrent wrong OTP guesses, no more than the configured number are evaluated.

**Milestone approval**

- Given a submitted milestone and a client member without `can_approve`, approval is rejected and status is unchanged.
- Given a valid approval, then in one transaction: status is approved, approver and time are set, the invoice is created or unlocked, an audit row is written, and notification jobs are enqueued.

**Split correctness** *(numbers are placeholders)*

- Given a ₦1,000,000 payment with a ₦15,000 provider fee, payouts and reserve sum to exactly ₦985,000, with any rounding remainder in the reserve.
- Given the same webhook delivered twice, exactly one payment and one set of payouts exist.

**Feedback**

- Given a feedback item flagged out of scope, accepting it as a task is blocked until the PM chooses "convert to change request" or "absorb" with a reason.

**Contract drift**

- Given a handler whose annotations changed but whose spec wasn't regenerated, CI fails.

**Restore**

- Given a production backup restored to a clean database, the server starts and the reconciliation job reports zero mismatches.

---

## 12. Future-proofing notes

- **Multiple studios:** keep an `organization_id` on top-level tables from day one, defaulting to a single row. It's cheap now and expensive later.
- **Equity model:** keep `payouts.method` and `projects.type` open enough to add non-cash compensation later.
- **AI features (P2):** draft weekly client digests, summarize feedback threads, estimate scope from a brief. Behind an interface, always human-approved.
- **Echo v5 is recent.** Wrap framework-specific code (context access, binding) in your own thin helpers so a future framework or major-version change touches a few files, not every handler.

---

## 13. Go and Flutter conventions

- Run `sqlc generate`, `swag init` and the Dart client generator through one `make generate` command; commit the output.
- Prefer small interfaces defined where they are used (the service defines what it needs from the repository).
- Never pass a sqlc struct to the API layer; map to DTOs.
- Wrap Echo's context in a few helpers (`currentUser(c)`, `parseUUIDParam(c, "id")`) so handlers stay short.
- One `errors.go` per domain with typed errors and their HTTP mapping documented in the handler annotations.
- Flutter: providers are the only place that touch repositories; repositories are the only place that touch the generated client.
- Keep generated code out of code review focus but in version control.
- Pin Go, Echo, Flutter and package versions; upgrade deliberately, with the full test suite and a staging deploy first.
- Write a one-day onboarding path: clone, `docker compose up` (Postgres), `make migrate`, `make seed`, `make test`, first endpoint and first screen.

---

## 14. Open questions to settle before build

1. **Who can approve milestones on the client side by default?** Owner only, or any member?
2. **Who pays payment-provider fees,** the studio or the client? (Affects REV-06.)
3. **Reporting currency:** NGN, USD, or both side by side?
4. **Are contributors ever paid per task or hourly** rather than by percentage split?
5. **How is the upfront deposit handled in the split:** distributed immediately or held until milestone approval?
6. **How long is client data kept after a project closes,** and who can request deletion?
7. **Is the intake form public from day one,** or is lead entry manual at first?
8. **Do clients ever see time reports** on retainer projects?
9. **Hosting:** VPS with Docker, or a managed platform? (Affects backups and deployment.)
10. **Out-of-scope policy:** always quote, or allow small absorbed changes within an allowance?
11. **Do you track hours from day one?** (Decides whether `time_entries` is in the MVP.)
12. **Can one client company ever need two separate billing contacts paying separately?**
13. **Should tasks have subtasks and labels in the first version,** or stay simple?
14. **Object storage provider:** a virtual USD card for R2, or Backblaze B2 (no card at signup)?
15. **API spec format:** stay on swaggo's stable Swagger 2.0, or move to OpenAPI 3.x?
16. **What is the real split?** The percentages in this document are placeholders.

---

## 15. Glossary

- **Foundry model:** fixed-price MVP delivery for clients.
- **Milestone:** a payable, approvable delivery unit.
- **Change request:** client-requested work beyond the agreed scope, quoted separately.
- **Reserve:** the share of each payment held by the studio for tools, subscriptions and overhead.
- **Webhook:** a message a payment provider sends your server when something happens (like a payment succeeding).
- **Presigned URL:** a temporary link that lets the app upload or download one file directly, without exposing storage credentials.
- **River:** the background job queue that runs inside the Go service and stores its jobs in Postgres.
- **SSE (Server-Sent Events):** a simple one-way live connection from server to app, used for notifications.
- **Dogfood:** using Studio OS to run Nok Labs itself.
