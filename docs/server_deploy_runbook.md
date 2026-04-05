# Server Deployment Runbook

This runbook is the recommended path to deploy the full stack on a fresh Ubuntu server.
It is ordered to satisfy network and service dependencies in this repository.

## 0) Access and Credential Lookup

Before running commands, confirm server access and deployment credentials using:
- `docs/access_credentials_lookup.md`

This prevents deployment interruptions caused by missing SSH credentials or secret values.

## 1) Prerequisites on Server

Install Docker Engine and Docker Compose plugin.

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin git
sudo systemctl enable docker
sudo systemctl start docker
```

## 2) Clone Repository

```bash
mkdir -p /opt
cd /opt
git clone https://github.com/apokavkos/eveintelligencecenter.git
cd eveintelligencecenter
```

## 3) Create Local Secret Files from Templates

```bash
./tools/init_local_config.sh
```

Edit these files and replace all `REPLACE_WITH_*` values:
- `infrastructure/seat-docker/.env`
- `infrastructure/eve-mcp-server/.env`
- `infrastructure/authelia/config/configuration.yml`
- `infrastructure/authelia/config/users_database.yml`

Helpful generation commands:

```bash
# 64-char secrets
openssl rand -hex 32

# Authelia OIDC private key
openssl genrsa 4096
```

## 4) Prepare Traefik Certificate Storage

```bash
mkdir -p infrastructure/seat-docker/acme
touch infrastructure/seat-docker/acme/acme.json
chmod 600 infrastructure/seat-docker/acme/acme.json
```

## 5) Deploy Core SeAT Stack First

Run SeAT with MariaDB and Traefik overlays together:

```bash
cd /opt/eveintelligencecenter/infrastructure/seat-docker
docker compose \
  -f docker-compose.yml \
  -f docker-compose.mariadb.yml \
  -f docker-compose.traefik.yml \
  up -d
```

This creates the shared Docker networks used by other apps:
- `seat-docker_seat-internal`
- `seat-docker_seat-frontend`

## 6) Deploy Remaining Services in Dependency Order

```bash
cd /opt/eveintelligencecenter/infrastructure/eve-sde
docker compose up -d

cd /opt/eveintelligencecenter/infrastructure/authelia
docker compose up -d

cd /opt/eveintelligencecenter/infrastructure/eve-mcp-server
docker compose up -d --build

cd /opt/eveintelligencecenter/infrastructure/metabase
docker compose up -d

cd /opt/eveintelligencecenter/infrastructure/grist
docker compose up -d

cd /opt/eveintelligencecenter/infrastructure/import-planner
docker compose up -d --build
```

## 7) Quick Validation

```bash
# Container status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Expected key containers
for c in \
  seat-docker-traefik-1 \
  seat-docker-front-1 \
  seat-docker-worker-1 \
  seat-docker-scheduler-1 \
  seat-docker-mariadb-1 \
  seat-docker-cache-1 \
  eve-sde \
  authelia \
  eve-mcp-server \
  metabase \
  grist \
  import-planner; do
  docker inspect -f '{{.Name}} => {{.State.Status}}' "$c" 2>/dev/null || echo "$c => missing"
done
```

Optional health script:

```bash
SEAT_ENV_FILE=/opt/eveintelligencecenter/infrastructure/seat-docker/.env \
  bash /opt/eveintelligencecenter/src/scripts/health_check.sh
```

## 8) Post-Deploy Smoke Checks

Confirm these hostnames resolve to your server public IP and load via HTTPS:
- `sso.apokavkos.com`
- `metabase.apokavkos.com`
- `imports.apokavkos.com`
- `evemcp.apokavkos.com`

If a service is unreachable, check logs:

```bash
# examples
cd /opt/eveintelligencecenter/infrastructure/seat-docker
docker compose logs --tail=100 traefik front worker scheduler mariadb

cd /opt/eveintelligencecenter/infrastructure/authelia
docker compose logs --tail=100 authelia
```

## 9) Upgrade Procedure

```bash
cd /opt/eveintelligencecenter
git pull

cd infrastructure/seat-docker
docker compose -f docker-compose.yml -f docker-compose.mariadb.yml -f docker-compose.traefik.yml up -d

cd ../eve-sde && docker compose up -d
cd ../authelia && docker compose up -d
cd ../eve-mcp-server && docker compose up -d --build
cd ../metabase && docker compose up -d
cd ../grist && docker compose up -d
cd ../import-planner && docker compose up -d --build
```
