#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

install -m 0750 "$script_dir/backup-payload.sh" /usr/local/sbin/shs-payload-backup
install -m 0644 "$script_dir/shs-payload-backup.service" /etc/systemd/system/shs-payload-backup.service
install -m 0644 "$script_dir/shs-payload-backup.timer" /etc/systemd/system/shs-payload-backup.timer
systemctl daemon-reload
systemctl enable --now shs-payload-backup.timer
systemctl start shs-payload-backup.service
systemctl --no-pager status shs-payload-backup.timer
