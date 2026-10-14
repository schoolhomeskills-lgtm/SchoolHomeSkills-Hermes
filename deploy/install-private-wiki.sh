#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:?Usage: install-private-wiki.sh SOURCE_DIR}"
root="${HERMES_WIKI_ROOT:-/srv/hermes/wiki}"

test -f "$source_dir/index.md"
install -d -m 0550 -o root -g hermes-wiki "$root/reference"
rsync -a --delete --exclude '.~lock*' "$source_dir/" "$root/reference/"
chown -R root:hermes-wiki "$root/reference"
find "$root/reference" -type d -exec chmod 0550 {} +
find "$root/reference" -type f -exec chmod 0440 {} +
install -d -m 2770 -o hermes -g hermes-wiki "$root/proposals/jonathan" "$root/livrables" "$root/sync-state"
find "$root/reference" -type f -print0 | xargs -0 sha256sum > "$root/sync-state/reference.sha256"
