// Studio OS backend API.
//
// @title           Studio OS API
// @version         1.0
// @description     Backend for Studio OS — auth, delivery, billing, and milestones.
// @host            localhost:8080
// @BasePath        /
// @securityDefinitions.apikey BearerAuth
// @in              header
// @name            Authorization
// @description     Type "Bearer" followed by a space and the JWT access token.
package main

import "fmt"

func main() {
	fmt.Println("Studio OS backend initialized")
}
