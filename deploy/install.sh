#!/usr/bin/env bash
set -euo pipefail

HERMES_IMAGE="${HERMES_IMAGE:-nousresearch/hermes-agent:v0.21.6}"
HERMES_IMAGE_DIGEST="${HERMES_IMAGE_DIGEST:-sha256:55e192fba0cd4fde61142abbff5adeacff40efdb482ccd0ff877924bd274f909}"
HERMES_ROOT="${HERMES_ROOT:-/srv/hermes}"
HERMES_WIKI_GID="${HERMES_WIKI_GID:-$(getent group hermes-wiki | cut -d: -f3)}"

if [[ ${EUID} -ne 0 ]]; then
  echo "Exécuter avec sudo." >&2
  exit 1
fi

install -d -m 0700 -o hermes -g hermes "$HERMES_ROOT/data" "$HERMES_ROOT/backups" "$HERMES_ROOT/logs"
docker pull "$HERMES_IMAGE"
actual="$(docker image inspect "$HERMES_IMAGE" --format '{{index .RepoDigests 0}}' | sed 's/.*@//')"
if [[ "$actual" != "$HERMES_IMAGE_DIGEST" ]]; then
  echo "Empreinte inattendue: $actual" >&2
  exit 1
fi

docker rm -f hermes 2>/dev/null || true
docker create \
  --name hermes \
  --restart unless-stopped \
  --memory 4g \
  --cpus 2 \
  --shm-size 1g \
  --group-add "$HERMES_WIKI_GID" \
  --log-driver json-file \
  --log-opt max-size=20m \
  --log-opt max-file=5 \
  -v "$HERMES_ROOT/data:/opt/data" \
  -v "$HERMES_ROOT/wiki:/srv/hermes/wiki" \
  -v "$HERMES_ROOT/workspaces:/srv/hermes/workspaces" \
  -p 127.0.0.1:9119:9119 \
  -e HERMES_DASHBOARD=1 \
  -e HERMES_DASHBOARD_HOST=0.0.0.0 \
  -e HERMES_DASHBOARD_PORT=9119 \
  "$HERMES_IMAGE" gateway run

echo "Conteneur créé mais non démarré. Configurez d’abord OAuth/OIDC dans $HERMES_ROOT/data/.env."
