param(
  [Parameter(Mandatory)] [string]$Path,
  [string]$SshTarget = 'ubuntu@vps-f61d79c0.vps.ovh.net'
)

$ErrorActionPreference = 'Stop'
$resolved = (Resolve-Path -LiteralPath $Path).Path
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$name = [IO.Path]::GetFileName($resolved)
$remote = "/srv/hermes/wiki/proposals/jonathan/$stamp-$name"

scp -r $resolved "${SshTarget}:$remote"
if ($LASTEXITCODE -ne 0) { throw 'Échec du transfert de la proposition.' }
Write-Host "Proposition ajoutée sans écrasement : $remote"
