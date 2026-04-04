# Changelog

All notable changes to the EVE Online Intelligence Center infrastructure will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.2.0] - 2026-04-02
### Added
- Standardized the codebase into a formal Infrastructure as Code (IaC) repository layout.
- Added `SYSTEM_PROMPT.md` for AI agent context injection.
- Added `/docs` folder for centralized knowledge.
- Implemented `import-planner`, a Streamlit Python app for calculating Jita Multibuy imports from Goonmetrics.

### Changed
- Refactored `metabase` to deploy inside the internal Traefik network instead of exposed Port 3000.
- Unified Traefik labels across the stack to strictly use `https` and `primary` resolvers.

## [1.1.0] - 2026-04-02
### Added
- **Global SSO:** Deployed Authelia to `sso.apokavkos.com` handling enterprise identity routing.
- Established Traefik `ForwardAuth` on Metabase, FastMCP, and Import Planner.
- Claude.ai Model Context Protocol connection converted to proper OAuth 2.1 / OIDC.

## [1.0.0] - 2026-04-01
### Added
- Initial deployment of SeAT Docker stack on Hetzner.
- Traefik edge router implementation map.
- EVE Static Data Export (SDE) MariaDB initialization.
- Bare-metal FastAPI MCP Server implementation using Basic Auth.
