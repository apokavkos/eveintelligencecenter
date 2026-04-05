# Access Credentials Lookup Guide

Use this guide when you need to find server login details quickly without storing secrets in Git.

## What You Need Before Deployment

Find or confirm these values:
- SSH host or IP for the server
- SSH username (usually root)
- SSH auth method (key or password)
- SSH private key location if key-based auth is used
- Domain and DNS provider access
- Current service secrets if rotating or restoring existing services

## Termius Lookup

1. Open Termius and go to Hosts.
2. Search for your server name or domain.
3. Open the host entry and check:
- Address
- Username
- Port
- Authentication method
4. If key-based auth is configured, open the linked key and confirm it is available on this machine.
5. Copy only non-secret metadata into your notes if needed.

Recommended host label format:
- EIC Production - root@apokavkos.com

## Bitwarden Lookup

Use Bitwarden for stored passwords, API secrets, and recovery notes.

1. Search vault for tags or names such as:
- eve
- hetzner
- apokavkos
- authelia
- seat
2. Check these item types:
- Login items for SSH/root access
- Secure notes for deployment steps
- Custom fields for DB password, EVE client secret, and OIDC values
3. Verify the item has recent update history and correct environment label.

Recommended Bitwarden fields:
- server_host
- ssh_username
- ssh_auth_method
- db_password
- eve_client_id
- eve_client_secret
- authelia_jwt_secret
- authelia_session_secret
- authelia_encryption_key
- authelia_oidc_hmac_secret
- authelia_oidc_private_key

## Notes Lookup

If you keep operational notes in Apple Notes or another notes app:
1. Search for runbook keywords:
- EIC deploy
- Hetzner rebuild
- Traefik
- Authelia
2. Confirm notes are current and match this repository structure.
3. Move durable credentials from notes into Bitwarden when possible.

## Security Rules

1. Never commit live secrets into this repo.
2. Keep runtime files local-only:
- infrastructure/seat-docker/.env
- infrastructure/eve-mcp-server/.env
- infrastructure/authelia/config/configuration.yml
- infrastructure/authelia/config/users_database.yml
3. Commit only template files ending in .example.
4. Rotate secrets immediately if you suspect exposure.

## Fast Verification Commands

Run these locally before deployment:

ssh -o BatchMode=yes root@apokavkos.com "echo connected"

If key auth fails, check key paths and agent state:

ls -la ~/.ssh
ssh-add -l
