# Architecture, responsabilités et limites

## Systèmes d’autorité

| Objet | Système d’autorité | Règle |
|---|---|---|
| Conversation, session, profil | Hermes | Un répertoire par profil indépendant |
| Tâche technique et dépendance | Kanban Hermes | Durable, attribuée, commentée, révisable |
| Validation métier | SchoolHomeSkills | Liée à l’organisation, la cible, l’action et la version exacte |
| Page et version de contenu | Payload | Brouillon relu avant preuve ; publication séparée |
| Objet commercial | Dolibarr | Permissions minimales et relecture objet par objet |
| Cours et progression | Moodle | Écriture limitée, cours caché avant autorisation |
| Connaissance approuvée | Wiki `reference/` | Lecture seule pour les agents |
| Proposition | Wiki `proposals/` | Jamais fusionnée silencieusement |

## Matrice Hermes

| Exigence | Natif Hermes v0.21.6 | Configuration | Extension SchoolHomeSkills |
|---|---|---|---|
| Tâches et dépendances | Kanban, liens parent/enfant | Board et profils | Portée métier et version de contexte |
| Travail parallèle | Swarm et workers par profil | Limites de concurrence | Branches DA/Rédaction et JOIN Web |
| Corrections | Request changes, commentaires | Règles de revue | Nouvelle version, accord périmé |
| Validation exacte | Revue de tâche | Contrat d’agent | Version et autorité vérifiées côté serveur |
| Limites de consommation | Analytics, modèles, itérations | Budgets/quotas à définir | Blocage avant appel payant |
| Arrêt et reprise | `pause`, `resume`, reclaim | Procédure d’exploitation | Résultat tardif invalidé |
| Preuves | Événements, logs, pièces jointes | Rétention et sauvegarde | Relecture Payload/Dolibarr/Moodle |

## Accès public

Le backend reste lié à `127.0.0.1`. nginx fournit HTTPS et WebSocket. Pour Internet, utiliser OAuth Nous Portal ou un OIDC commun. Le fournisseur Hermes par mot de passe est réservé à un réseau de confiance/VPN.

Les routes `/api/plugins/` demandent une attention spéciale : le modèle de sécurité du Kanban prévoit un usage localhost. Une exposition publique sûre impose une protection externe couvrant aussi ces routes, ou leur refus au proxy jusqu’à ce qu’une authentification amont les protège.

## Différences Web/Desktop

Le dashboard Web fournit le chat TUI embarqué, les profils, sessions et pages d’administration. Hermes Desktop utilise un backend distant et offre une interface native distincte. Le dashboard n’est pas une bibliothèque documentaire complète ; les livrables restent des fichiers/attachements ou sont consultés dans le Wiki/Obsidian.
