# EVE Online Intelligence Center

Welcome to the definitive Infrastructure as Code (IaC) repository for the EVE Online Intelligence Center. 

This environment is constructed linearly on a Hetzner Cloud VPS running Ubuntu 24.04 and strictly utilizes Docker containerization for maximum portability and security.

## Overview
The architecture is designed to marry live ESI data from **SeAT** with static data dumps from the **EVE SDE**, allowing advanced AI agents (Claude.ai / Gemini) and analytical tools (Metabase / Streamlit) to extract deeply layered intelligence.

## Access Portals
All web traffic is meticulously routed via the **Traefik** reverse proxy and secured by Let's Encrypt SSL certificates. The subdomains are actively mapped:

- `sso.apokavkos.com` (Global Authelia Identity Provider)
- `metabase.apokavkos.com` (Analytics Dashboard)
- `imports.apokavkos.com` (Streamlit Goonmetrics Importer)
- `evemcp.apokavkos.com` (AI Model Context Protocol Server)

## Folder Strategy
This repository is broken into logical components:
- `/docs/`: Human-readable technical architecture documents and cheat sheets.
- `/infrastructure/`: The Docker-Compose manifest bundles for every application.
- `/src/`: Internal python logic and sql query assets.
- `/tools/`: Bash utility scripts for managing certificates, passwords, and maintenance.

## Deployment Instructions (Recovery)
If the server suffers a catastrophic failure and is rebuilt, or if migrating to a new VPS host, you can recreate the entire ecosystem by pulling this repository.

1. Ensure Docker, `docker-compose`, and Traefik are installed.
2. Initialize the internal docker network: `docker network create seat-docker_seat-internal`
3. Enter each `/infrastructure/` folder.
4. Execute `docker compose up -d --build`.

> **See `/docs/` for specific deep-dive guides into configuring the database mappings or integrating MCP AI tools for the first time.**
