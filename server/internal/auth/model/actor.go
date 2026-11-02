package model

import "github.com/google/uuid"

type Actor struct {
	UserID        uuid.UUID
	Email         string
	IsSuspended   bool
	IsDeactivated bool
}
