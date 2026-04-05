#!/bin/bash
# Health check script for EVE Intelligence Center
# Run this on the Hetzner host to verify container statuses

SEAT_ENV_FILE="${SEAT_ENV_FILE:-/opt/seat-docker/.env}"
if [ -f "$SEAT_ENV_FILE" ]; then
    # shellcheck disable=SC1090
    set -a
    . "$SEAT_ENV_FILE"
    set +a
fi

echo "======================================"
echo "    EVE Intelligence Health Check     "
echo "======================================"

echo ""
echo "=> Checking System Resources..."
free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
df -h / | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
uptime | awk -F'( |,|:)+' '{print "System Uptime:", $6, "hours,", $7, "minutes (Load:", $15, $16, $17 ")"}'

echo ""
echo "=> Checking Docker Containers..."
EXPECTED_CONTAINERS=("eve-sde" "metabase" "seat-docker-mariadb-1" "seat-docker-worker-1" "seat-docker-scheduler-1" "seat-docker-front-1" "seat-docker-traefik-1" "seat-docker-cache-1")

for container in "${EXPECTED_CONTAINERS[@]}"; do
    STATUS=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null)
    if [ "$STATUS" == "running" ]; then
        echo -e "[ PASS ] $container is running."
    else
        echo -e "[ FAIL ] $container is NOT running (Status: $STATUS)!"
    fi
done

echo ""
echo "=> Checking Database Connections..."
# Check SeAT DB using configured service user by default.
if [ -n "$DB_PASSWORD" ]; then
    docker exec seat-docker-mariadb-1 mysqladmin -u "${DB_USERNAME:-seat}" -p"$DB_PASSWORD" ping --silent 2>/dev/null
else
    docker exec seat-docker-mariadb-1 mysqladmin -u "${DB_USERNAME:-seat}" ping --silent 2>/dev/null
fi
if [ $? -eq 0 ]; then
    echo "[ PASS ] SeAT MariaDB responds to ping."
else
    echo "[ WARN ] SeAT MariaDB ping failed. (Check $SEAT_ENV_FILE and Docker logs)"
fi

docker exec eve-sde mysqladmin -u root ping --silent 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[ PASS ] SDE MariaDB responds to ping."
else
    echo "[ WARN ] SDE MariaDB ping failed."
fi

echo "======================================"
