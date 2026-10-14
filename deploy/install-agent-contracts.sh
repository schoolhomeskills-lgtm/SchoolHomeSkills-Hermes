#!/usr/bin/env bash
set -euo pipefail

root="${1:-/srv/hermes/data}"
source_dir="${2:-$(cd "$(dirname "$0")/.." && pwd)/agents}"
skill_dir="${3:-$(cd "$(dirname "$0")/.." && pwd)/skills/wiki-governance}"

for profile in coordinateur marketing redaction directionartistique web; do
  target="$root/profiles/$profile"
  test -d "$target" || { echo "Profil absent: $profile" >&2; exit 1; }
  install -m 0600 "$source_dir/$profile/SOUL.md" "$target/SOUL.md"
  install -m 0600 "$source_dir/$profile/AGENTS.md" "$target/AGENTS.md"
  install -d -m 0700 "$target/skills/wiki-governance"
  install -m 0600 "$skill_dir/SKILL.md" "$target/skills/wiki-governance/SKILL.md"
done

echo "Contrats installés dans cinq profils distincts."
