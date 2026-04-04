#!/bin/bash
# Health check script for EVE Intelligence Center
# Run this on the Hetzner host to verify container statuses

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
# Simple check to see if port 3306 is open inside the Mariadb containers
docker exec seat-docker-mariadb-1 mysqladmin -u root -p"$DB_PASSWORD" ping --silent 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[ PASS ] SeAT MariaDB responds to ping."
else
    echo "[ WARN ] SeAT MariaDB ping failed. (Check \$DB_PASSWORD or Docker logs)"
fi

docker exec eve-sde mysqladmin -u root ping --silent 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[ PASS ] SDE MariaDB responds to ping."
else
    echo "[ WARN ] SDE MariaDB ping failed."
fi

echo "======================================"
