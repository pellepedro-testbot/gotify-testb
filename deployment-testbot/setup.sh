#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
echo "Building Gotify from source + starting (this may take a while)..."
docker compose -f docker-compose.yml up -d --build
echo "Waiting for health (up to 10 min)..."
for i in $(seq 1 200); do
  if curl -sf -m3 http://localhost:8090/health | grep -q green; then break; fi
  sleep 3; [ "$i" = 200 ] && { echo "unhealthy after 10min"; docker compose logs --tail 80; exit 1; }
done
echo "Setup complete"
