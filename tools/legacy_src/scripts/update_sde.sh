#!/bin/bash
# update_sde.sh
# Downloads the latest Fuzzwork MySQL SDE dump and pipes it directly into the eve-sde container

echo "========================================="
echo "   EVE SDE Update Script (Fuzzwork)      "
echo "========================================="

echo "[1/3] Downloading latest SDE..."
curl -o /tmp/mysql-latest.tar.bz2 https://www.fuzzwork.co.uk/dump/mysql-latest.tar.bz2

echo "[2/3] Extracting and preparing SQL..."
# The dump extracts to a file named 'sde.sql' or similar, but Fuzzworks typically extracts to a directory or a single `.sql` file.
# bzcat allows us to stream it without taking up too much disk space.
# We pipe it into the container.
echo "Piping standard MySQL DB to eve-sde container (this will overwrite the 'sde' schema entirely)..."

# Ensure container is running
if [ "$(docker ps -q -f name=eve-sde)" ]; then
    echo "eve-sde container is running. Pushing data..."
    bzcat /tmp/mysql-latest.tar.bz2 | docker exec -i eve-sde mysql -u root
    echo "[3/3] SDE Update Complete!"
else
    echo "ERROR: eve-sde container is not running! Aborting."
fi

# Cleanup
echo "Cleaning up temp files..."
rm -f /tmp/mysql-latest.tar.bz2
echo "Done."
