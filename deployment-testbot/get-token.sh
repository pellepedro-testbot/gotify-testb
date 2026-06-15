#!/usr/bin/env bash
set -euo pipefail
U="${GOTIFY_ADMIN:-admin}"; P="${GOTIFY_PASS:-admin}"
# Wait for health before minting token
for i in $(seq 1 20); do
  if curl -sf -m3 http://localhost:8090/health | grep -q green; then break; fi
  sleep 3; [ "$i" = 20 ] && { echo "Server not healthy" >&2; exit 1; }
done
curl -sf -u "$U:$P" -X POST "http://localhost:8090/client" \
  -H 'Content-Type: application/json' \
  -d "{\"name\":\"testbot-$(date +%s)\"}" \
  | python3 -c "import json,sys;print(json.load(sys.stdin)['token'])"
