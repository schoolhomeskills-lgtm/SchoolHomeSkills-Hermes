#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Exécuter avec sudo." >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install -m 0750 "$script_dir/backup.sh" /usr/local/sbin/shs-hermes-backup
install -m 0750 "$script_dir/status.sh" /usr/local/sbin/shs-hermes-status
install -m 0644 "$script_dir/shs-hermes-backup.service" /etc/systemd/system/shs-hermes-backup.service
install -m 0644 "$script_dir/shs-hermes-backup.timer" /etc/systemd/system/shs-hermes-backup.timer
systemctl daemon-reload
systemctl enable --now shs-hermes-backup.timer
systemctl start shs-hermes-backup.service
systemctl --no-pager status shs-hermes-backup.timer

