#!/usr/bin/env bash
set -euo pipefail

root="${HERMES_ROOT:-/srv/hermes}"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
dest="$root/backups/hermes-$stamp.tar.gz"
tmp="$dest.tmp"

install -d -m 0700 "$root/backups"
tar --xattrs --acls -C "$root" -czf "$tmp" data wiki
mv "$tmp" "$dest"
sha256sum "$dest" > "$dest.sha256"
find "$root/backups" -maxdepth 1 -type f -name 'hermes-*.tar.gz' -mtime +14 -delete
find "$root/backups" -maxdepth 1 -type f -name 'hermes-*.tar.gz.sha256' -mtime +14 -delete
echo "$dest"
