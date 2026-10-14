param(
  [string]$SshTarget = 'ubuntu@vps-f61d79c0.vps.ovh.net',
  [string]$Vault = "$env:USERPROFILE\Documents\SchoolHomeSkills-Wiki"
)

$ErrorActionPreference = 'Stop'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$staging = Join-Path $env:TEMP "shs-wiki-$stamp"
$reference = Join-Path $Vault 'reference-serveur'
$proposals = Join-Path $Vault 'propositions-jonathan'
$history = Join-Path $Vault '.history'

New-Item -ItemType Directory -Force -Path $staging, $reference, $proposals, $history | Out-Null
scp -r "${SshTarget}:/srv/hermes/wiki/reference/." $staging
if ($LASTEXITCODE -ne 0) { throw 'Échec du téléchargement du Wiki.' }

robocopy $reference (Join-Path $history $stamp) /E /COPY:DAT /R:1 /W:1 | Out-Null
robocopy $staging $reference /MIR /COPY:DAT /R:1 /W:1 | Out-Null
Get-ChildItem -LiteralPath $reference -Recurse -File | ForEach-Object { $_.IsReadOnly = $true }

Write-Host "Référence mise à jour : $reference"
Write-Host "Propositions locales séparées : $proposals"
