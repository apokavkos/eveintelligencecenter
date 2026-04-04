#!/bin/bash
# monitor_workers.sh
# Check the SeAT background worker queue sizes and logs

echo "== SeAT Worker Monitor =="
echo "Fetching failed jobs..."
docker exec seat-docker-worker-1 php artisan queue:failed 2>/dev/null

echo ""
echo "To retry all failed jobs, run: docker exec seat-docker-worker-1 php artisan queue:retry all"
echo ""

echo "Fetching recent worker logs (last 20 lines)..."
docker logs --tail 20 seat-docker-worker-1
