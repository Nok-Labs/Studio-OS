// @title           Studio OS API
// @version         1.0
// @description     Backend for Studio OS — Auth and User Management
// @host            localhost:8080
// @BasePath        /
// @securityDefinitions.apikey  BearerAuth
// @in                          header
// @name                        Authorization
// @description                 Type "Bearer" followed by a space and the JWT access token.
package main

import (
	"context"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"server/internal/auth/config"
	authhandler "server/internal/auth/handler"
	"server/internal/auth/repository"
	"server/internal/auth/service"
	"server/internal/auth/utils"
	db "server/internal/db/generated"
	"server/internal/httpserver"
	"server/internal/mailer"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/joho/godotenv"
)

func main() {
	// Initialize structured logging
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	// Load .env file if it exists (ignore error in production)
	_ = godotenv.Load()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// 1. Database Connection
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		slog.Warn("DATABASE_URL is not set, using default local postgres url")
		dbURL = "postgres://postgres:postgres@localhost:5432/studio_db?sslmode=disable"
	}

	pool, err := pgxpool.New(ctx, dbURL)
	if err != nil {
		slog.Error("Failed to connect to database", "error", err)
		os.Exit(1)
	}
	defer pool.Close()

	if err := pool.Ping(ctx); err != nil {
		slog.Error("Failed to ping database", "error", err)
		os.Exit(1)
	}
	slog.Info("Connected to PostgreSQL")

	// 2. Initialize Dependencies
	queries := db.New(pool)
	
	// Create the Auth Repository
	authRepo := repository.NewAuthRepository(queries)

	// Create JWT Issuer
	jwtSecret := os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		slog.Warn("JWT_SECRET is not set, using a fallback secret (UNSAFE FOR PRODUCTION)")
		jwtSecret = "super-secret-fallback-key"
	}
	jwtIssuer := utils.NewJWTIssuer(jwtSecret)

	// Initialize Mailer (NoOp for local dev until real one is integrated)
	mailService := mailer.NewNoOpMailer()

	// Initialize Auth Config
	authCfg := config.DefaultConfig()
	if err := authCfg.Validate(); err != nil {
		slog.Error("Invalid auth configuration", "error", err)
		os.Exit(1)
	}

	// 3. Initialize Services
	authServices := service.NewServices(authRepo, authCfg, jwtIssuer, mailService)

	// 4. Initialize Handlers
	authHandler := authhandler.NewAuthHandler(authServices)
	handlers := httpserver.Handlers{
		Auth: authHandler,
	}

	// 5. Build HTTP Router
	allowedOrigins := []string{"http://localhost:3000", "http://localhost:5173"}
	router := httpserver.NewRouter(handlers, jwtIssuer, allowedOrigins)

	// 6. Start HTTP Server with Graceful Shutdown
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	srv := &http.Server{
		Addr:    ":" + port,
		Handler: router,
	}

	go func() {
		slog.Info("Starting server", "port", port)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			slog.Error("Server startup failed", "error", err)
			os.Exit(1)
		}
	}()

	// Wait for interrupt signal for graceful shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	slog.Info("Shutting down server gracefully...")

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer shutdownCancel()

	if err := srv.Shutdown(shutdownCtx); err != nil {
		slog.Error("Server forced to shutdown", "error", err)
		os.Exit(1)
	}

	slog.Info("Server exited cleanly")
}
