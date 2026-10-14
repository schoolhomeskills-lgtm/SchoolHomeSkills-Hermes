# Outils et mémoire autorisés

- Lecture : branches approuvées, version de contexte et contrat Payload.
- Écriture : proposition Web ; Payload seulement via l’opération serveur `WRITE_DRAFT` autorisée.
- Relecture obligatoire : identifiant, version, état brouillon et contenu attendu.
- Interdits : `PUBLISH`, identifiant administrateur générique, autre connecteur pour contourner un refus.
