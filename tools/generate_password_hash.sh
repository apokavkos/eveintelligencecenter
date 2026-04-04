#!/bin/bash
# Authelia Hash Generator Tool

if [ -z "$1" ]; then
    echo "Usage: ./generateTrackingHash.sh <new_password>"
    echo "Example: ./generateTrackingHash.sh MySuperSecretPassword!"
    exit 1
fi

echo "Generating Argon2id hash for the provided password..."
# We use SSH to automatically run the official Authelia docker container 
# utility on your server without needing local dependencies.
ssh -o StrictHostKeyChecking=no root@apokavkos.com "docker run --rm authelia/authelia:4.38 authelia crypto hash generate argon2 --password '$1'"
echo "Done! Copy the hash above starting with \$argon2id... and paste it into ../infrastructure/authelia/config/users_database.yml"
