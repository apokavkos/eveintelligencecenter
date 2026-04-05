#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

copy_if_missing() {
  local src="$1"
  local dst="$2"
  if [ -f "$dst" ]; then
    echo "[skip] $dst already exists"
  else
    cp "$src" "$dst"
    echo "[ok]   created $dst"
  fi
}

copy_if_missing "$ROOT_DIR/infrastructure/seat-docker/.env.example" "$ROOT_DIR/infrastructure/seat-docker/.env"
copy_if_missing "$ROOT_DIR/infrastructure/eve-mcp-server/.env.example" "$ROOT_DIR/infrastructure/eve-mcp-server/.env"
copy_if_missing "$ROOT_DIR/infrastructure/authelia/config/configuration.yml.example" "$ROOT_DIR/infrastructure/authelia/config/configuration.yml"
copy_if_missing "$ROOT_DIR/infrastructure/authelia/config/users_database.yml.example" "$ROOT_DIR/infrastructure/authelia/config/users_database.yml"

echo
echo "Local config bootstrap complete."
echo "Next: edit the generated files and replace all REPLACE_WITH_* values."
