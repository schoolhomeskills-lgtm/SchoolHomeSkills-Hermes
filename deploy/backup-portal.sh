#!/usr/bin/env bash
set -euo pipefail

data=/srv/schoolhomeskills-portal/data
backup_root=/srv/schoolhomeskills-portal/backups
container=shs-portal
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
dest="$backup_root/portal-$stamp.tar.gz"
tmp="$dest.tmp"
container_was_running=false

cleanup() {
  rm -f "$tmp"
  if [[ "$container_was_running" == true ]]; then docker start "$container" >/dev/null; fi
}
trap cleanup EXIT

[[ "$(readlink -f "$data")" == /srv/schoolhomeskills-portal/data ]] || { echo "Chemin de données inattendu" >&2; exit 1; }
install -d -m 0700 "$backup_root"
if [[ "$(docker inspect -f '{{.State.Running}}' "$container" 2>/dev/null || true)" == true ]]; then
  container_was_running=true
  docker stop -t 30 "$container" >/dev/null
fi
tar --xattrs --acls -C "$data" -czf "$tmp" .
mv "$tmp" "$dest"
sha256sum "$dest" > "$dest.sha256"
find "$backup_root" -maxdepth 1 -type f -name 'portal-*.tar.gz' -mtime +14 -delete
find "$backup_root" -maxdepth 1 -type f -name 'portal-*.tar.gz.sha256' -mtime +14 -delete
echo "$dest"
