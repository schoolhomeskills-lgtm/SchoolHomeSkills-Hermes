# Fournisseur ChatGPT/Codex et Payload

## Inférence sans clé API

Hermes v0.21.6 utilise le fournisseur `openai-codex`, authentifié par le flux OAuth propre à Hermes. Le modèle validé est `gpt-6.1-sol`. Le même compte et le même quota alimentent le profil principal et les profils `coordinateur`, `marketing`, `redaction`, `directionartistique` et `web`.

Les fichiers `.env` actifs des profils ne contiennent aucune clé OpenAI. Les anciennes clés sont conservées hors du chemin chargé, dans un répertoire privé en mode `0700`, uniquement pour un retour arrière administré. Aucun fournisseur de repli n'est configuré. Les tâches auxiliaires en mode `auto`, comme le titre et la compression, suivent donc le fournisseur principal.

Contrôles d'exploitation :

```bash
sudo docker exec hermes hermes auth status openai-codex
sudo docker exec hermes hermes usage
sudo docker exec hermes hermes fallback list
sudo docker exec hermes hermes doctor
```

Le catalogue affiché n'est pas une preuve de droit. Un test réel borné doit réussir et son rapport `--usage-file` doit indiquer `provider: openai-codex`, le modèle attendu et `cost_status: included`.

## Payload

Payload 3.90.2 fonctionne dans le conteneur `shs-payload`, lié uniquement à `127.0.0.1:3001`. Le volume `shs_payload_data` contient sa base SQLite. Le compte technique et sa clé restent dans `/srv/schoolhomeskills-platform/.env.platform`, en mode `0600`, jamais dans Git ni dans le navigateur.

Le scénario technique de coordination a vérifié une écriture réelle, sa relecture, les branches parallèles rédaction/direction artistique et le statut non publié. Ce scénario fixture ne vaut pas approbation d'un contenu métier réel. Une publication reste une action humaine séparée.

Commandes :

```bash
sudo docker ps --filter name=shs-payload
sudo docker logs --tail 200 shs-payload
sudo /usr/local/sbin/shs-payload-backup
sudo systemctl status shs-payload-backup.timer
```

La sauvegarde arrête brièvement Payload afin de figer SQLite, archive le volume, produit une empreinte SHA-256, puis redémarre le conteneur même en cas d'échec.
