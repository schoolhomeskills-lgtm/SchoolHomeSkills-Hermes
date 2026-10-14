#!/usr/bin/env bash
set -euo pipefail

docker ps --filter name='^/hermes$' --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
curl -fsS http://127.0.0.1:9119/api/status
echo
docker exec hermes hermes doctor
