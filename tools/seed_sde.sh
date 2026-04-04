#!/bin/bash
# EVE Online SDE Seeding Utility
# Downloads the latest MariaDB formatted Static Data Export from Fuzzworks
# and seamlessly pipes it into the IaC `eve-sde` Docker container.

# We run this on the host server directly.
echo "[~] Beginning EVE SDE Data Pipeline..."

echo "[+] Downloading mysql-latest.tar.bz2 from Fuzzwork..."
wget -q --show-progress -O /tmp/sde.tar.bz2 https://www.fuzzwork.co.uk/dump/mysql-latest.tar.bz2

echo "[+] SDE Downloaded. Creating 'eve_sde' database schema if missing..."
docker exec eve-sde mariadb -e "CREATE DATABASE IF NOT EXISTS eve_sde;"

# The BZ2 compression shrinks the database from several gigabytes down to ~60MB.
# tar -O lets us stream that data instantly into MariaDB memory without exploding the disk
echo "[+] Decompressing and piping SQL directly into 'eve-sde' Container. Please stand by, this takes up to 2-5 minutes..."
tar -xjf /tmp/sde.tar.bz2 -O | docker exec -i eve-sde mariadb eve_sde

echo "[+] Cleaning up temp file..."
rm /tmp/sde.tar.bz2

echo "[$] Pipeline Success! Your SDE database is now fully populated in the 'eve_sde' database!"
