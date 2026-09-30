package httpserver

import (
	"net/http"
	"time"

	"server/internal/auth/handler"
	"server/internal/auth/utils"

	_ "server/docs"

	"github.com/go-chi/httprate"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	echoSwagger "github.com/swaggo/echo-swagger"
)

// Handlers bundles every domain's HTTP handler so we don't have a giant param list.
type Handlers struct {
	Auth *handler.AuthHandler
}

// NewRouter constructs the global HTTP pipeline with middlewares and routes.
func NewRouter(h Handlers, jwtIssuer *utils.JWTIssuer, allowedOrigins []string) *echo.Echo {
	e := echo.New()

	// Global middlewares
	e.Use(middleware.RequestID())
	// RequestLogger, not Logger: the latter is deprecated (SA1019) and the
	// former is the maintained equivalent.
	e.Use(middleware.RequestLogger())
	e.Use(middleware.Recover())

	// Every request body in this API is a small JSON object (the largest is a
	// password reset, well under 1KB). Without a ceiling, c.Bind streams the
	// body into a json.Decoder with nothing stopping it, so a single
	// unauthenticated request with a multi-gigabyte body is enough to OOM the
	// process. Registered after Recover so an oversized body is a clean 413
	// rather than a panic.
	e.Use(middleware.BodyLimit("16K"))

	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins:     allowedOrigins,
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Accept", "Authorization", "Content-Type"},
		AllowCredentials: false,
		MaxAge:           300,
	}))

	// Interactive OpenAPI / Swagger UI documentation endpoint
	e.GET("/swagger/*", echoSwagger.WrapHandler)

	// Health check (Public)
	e.GET("/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"status": "ok"})
	})

	// Rate limiter for the authentication endpoints.
	//
	// Applied to more than just login: /verify, /reset-password and
	// /forgot-password are the unauthenticated endpoints where an attacker can
	// make the server burn CPU or send mail at will. /reset-password in
	// particular runs a bcrypt hash at the configured cost (~260ms at cost 12)
	// before it ever consults the OTP table, so an unthrottled caller gets a
	// free CPU-burn primitive. The attempt counters in the service layer are
	// the second layer of defence; this is the first.
	loginRateLimit := echo.WrapMiddleware(
		httprate.LimitByIP(5, 1*time.Minute),
	)

	// Auth Public Routes
	authGroup := e.Group("/auth")
	authGroup.POST("/signup", h.Auth.Signup, loginRateLimit)
	authGroup.POST("/verify", h.Auth.Verify, loginRateLimit)
	authGroup.POST("/resend-otp", h.Auth.ResendOTP, loginRateLimit)
	authGroup.POST("/login", h.Auth.Login, loginRateLimit)
	authGroup.POST("/refresh", h.Auth.Refresh, loginRateLimit)
	authGroup.POST("/logout", h.Auth.Logout, loginRateLimit)
	authGroup.POST("/forgot-password", h.Auth.ForgotPassword, loginRateLimit)
	authGroup.POST("/reset-password", h.Auth.ResetPassword, loginRateLimit)
	authGroup.GET("/check-username", h.Auth.CheckUsername, loginRateLimit)

	// Protected API Routes
	v1 := e.Group("/v1")
	v1.Use(handler.RequireAuth(jwtIssuer))

	// User/Profile Protected Routes
	userGroup := v1.Group("/users")
	userGroup.GET("/me", h.Auth.GetProfile)
	userGroup.PATCH("/me", h.Auth.UpdateProfile)
	userGroup.POST("/me/password", h.Auth.ChangePassword)

	return e
}
