#!/usr/bin/env bash
set -euo pipefail

backup_root="${PAYLOAD_BACKUP_ROOT:-/srv/schoolhomeskills-platform/backups}"
container="${PAYLOAD_CONTAINER:-shs-payload}"
volume="${PAYLOAD_VOLUME:-shs_payload_data}"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
dest="$backup_root/payload-$stamp.tar.gz"
tmp="$dest.tmp"
container_was_running=false

cleanup() {
  rm -f "$tmp"
  if [[ "$container_was_running" == true ]]; then
    docker start "$container" >/dev/null
  fi
}

trap cleanup EXIT
install -d -m 0700 "$backup_root"

mountpoint="$(docker volume inspect -f '{{.Mountpoint}}' "$volume")"
case "$mountpoint" in
  /var/lib/docker/volumes/*/_data) ;;
  *) echo "Refus du chemin de volume inattendu : $mountpoint" >&2; exit 1 ;;
esac

if [[ "$(docker inspect -f '{{.State.Running}}' "$container" 2>/dev/null || true)" == true ]]; then
  container_was_running=true
  docker stop -t 30 "$container" >/dev/null
fi

tar --xattrs --acls -C "$mountpoint" -czf "$tmp" .
mv "$tmp" "$dest"
sha256sum "$dest" > "$dest.sha256"
find "$backup_root" -maxdepth 1 -type f -name 'payload-*.tar.gz' -mtime +14 -delete
find "$backup_root" -maxdepth 1 -type f -name 'payload-*.tar.gz.sha256' -mtime +14 -delete
echo "$dest"
