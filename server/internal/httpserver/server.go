package httpserver

import (
	"net/http"
	"time"

	"server/internal/auth/handler"
	"server/internal/auth/utils"

	"github.com/go-chi/httprate"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	echoSwagger "github.com/swaggo/echo-swagger"
	_ "server/docs"
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
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	
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

	// Rate limiter specifically for login/signup endpoints
	loginRateLimit := echo.WrapMiddleware(
		httprate.LimitByIP(5, 1*time.Minute),
	)

	// Auth Public Routes
	authGroup := e.Group("/auth")
	authGroup.POST("/signup", h.Auth.Signup, loginRateLimit)
	authGroup.POST("/verify", h.Auth.Verify)
	authGroup.POST("/resend-otp", h.Auth.ResendOTP, loginRateLimit)
	authGroup.POST("/login", h.Auth.Login, loginRateLimit)
	authGroup.POST("/refresh", h.Auth.Refresh)
	authGroup.POST("/logout", h.Auth.Logout)
	authGroup.POST("/forgot-password", h.Auth.ForgotPassword)
	authGroup.POST("/reset-password", h.Auth.ResetPassword)
	authGroup.GET("/check-username", h.Auth.CheckUsername)

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
