package utils

import (
	"fmt"

	"golang.org/x/crypto/bcrypt"
)

// dummyHash is a genuine bcrypt hash (cost 12) of a random string that is not
// a credential anyone can present. It is compared against on the "user not
// found" login path so that a request costs the same whether or not the email
// exists (requirement AUTH-17).
//
// It must be a real, parseable hash produced by bcrypt.GenerateFromPassword at
// the same cost as PasswordConfig.BcryptCost. If it were malformed, Go's bcrypt
// would return early from newFromHash and skip the expensive key schedule, and
// the dummy comparison would return measurably faster than a real one — turning
// this mitigation into a user-enumeration oracle. TestDummyPasswordCompareDoes
// notShortCircuit in password_test.go guards that property.
//
// Regenerate with:
//
//	go run ./scripts/gen_dummy_hash.go
const dummyHash = "$2a$12$N9/ZAeDfgdzYgsk7oQQVlO92wyfWa0Xr.m78mafvKCW4lKY1SqGXm"

// HashPassword hashes a password string using bcrypt with the specified cost factor.
//
// An out-of-range cost is a configuration error, not something to paper over:
// silently substituting bcrypt.DefaultCost (10) would quietly weaken a system
// configured for 12, so the invalid value is returned as an error instead.
func HashPassword(password string, cost int) (string, error) {
	if cost < bcrypt.MinCost || cost > bcrypt.MaxCost {
		return "", &InvalidCostError{Cost: cost}
	}
	hashBytes, err := bcrypt.GenerateFromPassword([]byte(password), cost)
	if err != nil {
		return "", err
	}
	return string(hashBytes), nil
}

// InvalidCostError reports a bcrypt cost outside the supported range.
type InvalidCostError struct {
	// Cost is the rejected value.
	Cost int
}

// Error implements the error interface.
func (e *InvalidCostError) Error() string {
	return fmt.Sprintf("bcrypt: cost %d is outside allowed inclusive range %d..%d",
		e.Cost, bcrypt.MinCost, bcrypt.MaxCost)
}

// CheckPassword verifies whether a plaintext password matches a stored bcrypt hash.
func CheckPassword(hash, password string) bool {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(password)) == nil
}

// DummyPasswordCompare performs a dummy bcrypt check against a fixed hash
// to ensure response timing stays consistent on failed logins.
//
// The result is intentionally discarded: there is no correct password for this
// hash, so the only purpose is to spend the same CPU a real check would.
func DummyPasswordCompare(password string) {
	_ = bcrypt.CompareHashAndPassword([]byte(dummyHash), []byte(password))
}
