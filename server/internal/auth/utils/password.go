package utils

import "golang.org/x/crypto/bcrypt"

// dummyHash is a precomputed valid bcrypt hash used to prevent timing attacks.
// When an email is not found during login, we compare against this dummy hash
// so that login attempts take the exact same amount of time regardless of whether
// the email exists in the database (requirement AUTH-17).
const dummyHash = "$2a$12$e8uq4fDqZ9N5aYJzFq1Z3uP0cQ3Zt4xL9bM6kO7wR8vS1tU2vW3xY"

// HashPassword hashes a password string using bcrypt with the specified cost factor.
func HashPassword(password string, cost int) (string, error) {
	if cost < bcrypt.MinCost || cost > bcrypt.MaxCost {
		cost = bcrypt.DefaultCost
	}
	hashBytes, err := bcrypt.GenerateFromPassword([]byte(password), cost)
	if err != nil {
		return "", err
	}
	return string(hashBytes), nil
}

// CheckPassword verifies whether a plaintext password matches a stored bcrypt hash.
func CheckPassword(hash, password string) bool {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(password)) == nil
}

// DummyPasswordCompare performs a dummy bcrypt check against a fixed hash
// to ensure response timing stays consistent on failed logins.
func DummyPasswordCompare(password string) {
	_ = bcrypt.CompareHashAndPassword([]byte(dummyHash), []byte(password))
}
