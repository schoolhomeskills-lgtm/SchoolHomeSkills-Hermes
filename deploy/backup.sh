#!/usr/bin/env bash
set -euo pipefail

root="${HERMES_ROOT:-/srv/hermes}"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
dest="$root/backups/hermes-$stamp.tar.gz"
tmp="$dest.tmp"
container_was_running=false

cleanup() {
  rm -f "$tmp"
  if [[ "$container_was_running" == true ]]; then
    docker start hermes >/dev/null
  fi
}

trap cleanup EXIT

install -d -m 0700 "$root/backups"

# Stop the container briefly so SQLite/WAL files and profile state form one
# consistent snapshot. Package environments and caches are reproducible from
# Hermes' persisted package configuration and are deliberately not archived.
if [[ "$(docker inspect -f '{{.State.Running}}' hermes 2>/dev/null || true)" == true ]]; then
  container_was_running=true
  docker stop -t 30 hermes >/dev/null
fi

tar --xattrs --acls \
  --exclude='data/cache' \
  --exclude='data/.npm' \
  --exclude='data/installs' \
  --exclude='data/*.sock' \
  --exclude='data/state/*.sock' \
  -C "$root" -czf "$tmp" data wiki
mv "$tmp" "$dest"
sha256sum "$dest" > "$dest.sha256"
find "$root/backups" -maxdepth 1 -type f -name 'hermes-*.tar.gz' -mtime +14 -delete
find "$root/backups" -maxdepth 1 -type f -name 'hermes-*.tar.gz.sha256' -mtime +14 -delete
echo "$dest"
