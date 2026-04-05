# Authelia Global SSO: Operational Reference

This document serves as the operational baseline for maintaining the Global Single Sign-On (SSO) architecture deployed on the EVE Intelligence Center Hetzner server. 

**Any AI agent or user interacting with Authentication should read this context heavily.**

## Architecture Overview
The server uses **Authelia** deployed at `/opt/authelia` as the identity provider. 
It protects routes seamlessly by hooking directly into the Traefik edge router via the `authelia@docker` ForwardAuth middleware.

- **Access URL:** `https://sso.apokavkos.com`
- **OIDC Discovery:** `https://sso.apokavkos.com/.well-known/openid-configuration`
- **Backend Configuration:** Flat-file Argon2 `users_database.yml`

## Reading "Emails" & OTP Notifications (Crucial)
Because we have bypassed configuring outbound SMTP integrations (like Sendgrid/Mailgun), Authelia uses the `filesystem` notifier fallback. 
**Authelia does not send actual emails.** 

Whenever the system requires identity verification—such as registering a TOTP device (Google Authenticator), generating a One-Time Password, or resetting an account password—**it prints the "email" physically into a text file mounted on the Hetzner host.**

If a user hits a block indicating "An email with a one-time code has been sent", run the following command to retrieve the simulated inbox:

```bash
ssh apokavkos.com "cat /opt/authelia/config/notification.txt"
```
*The file will contain the exact URLs or One-Time Passwords needed to complete the 2FA handshake in the browser.*

## Password Generation
Flat-file deployments strictly enforce robust `Argon2id` cryptographic hashes. Plain text passwords will crash the system.

Use local config files copied from templates:
- `infrastructure/authelia/config/configuration.yml.example` -> `infrastructure/authelia/config/configuration.yml`
- `infrastructure/authelia/config/users_database.yml.example` -> `infrastructure/authelia/config/users_database.yml`

The generated `configuration.yml` and `users_database.yml` are intentionally ignored by Git.

To add users to `users_database.yml` or change passwords, utilize the helper script located in this directory:
```bash
# Execute locally:
./generate_password_hash.sh "MyNewPassword123!"
```
*This script automatically proxies an SSH connection into the production Authelia container, executes the official `authelia crypto hash generate argon2` daemon, and outputs the safely salted hash ready for pasting into your database config.*

## MCP OAuth (OpenID Connect)
Authelia inherently acts as the OIDC provider for `claude-ai-mcp` connectors.
It accepts and validates `Authorization: Bearer <token>` requests natively. If an application (like Streamlit or an MCP python server) needs securing:
1. Do not write custom python JWT validators.
2. In the deployment `docker-compose.yml`, apply the Traefik tag: 
   `"traefik.http.routers.[name].middlewares=authelia@docker"`
3. Authelia will gracefully catch Bearer tokens from Claude.ai and pass them securely to the container backend.
