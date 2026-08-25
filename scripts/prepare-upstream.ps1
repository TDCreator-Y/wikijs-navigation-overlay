[CmdletBinding()]
param(
  [string]$WikiVersion = 'v2.5.314',
  [string]$WikiCommit = '6f042e97cc2d3acda6b6ff611de8e0faacce91c1',
  [string]$Destination = ''
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if ([string]::IsNullOrWhiteSpace($Destination)) {
  $Destination = Join-Path $repoRoot '.build\wikijs'
}

$patchPath = Join-Path $repoRoot 'patches\wikijs-2.5.x-navigation.patch'
if (-not (Test-Path -LiteralPath $patchPath)) {
  throw "Patch not found: $patchPath"
}

if (Test-Path -LiteralPath $Destination) {
  $gitDir = Join-Path $Destination '.git'
  if (-not (Test-Path -LiteralPath $gitDir)) {
    throw "Destination exists but is not a Git checkout: $Destination"
  }
  & git -C $Destination status --short
  if ($LASTEXITCODE -ne 0) { throw 'Unable to inspect the upstream checkout.' }
} else {
  $parent = Split-Path -Parent $Destination
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  & git clone --depth 1 --branch $WikiVersion https://github.com/Requarks/wiki.git $Destination
  if ($LASTEXITCODE -ne 0) { throw "Unable to clone Wiki.js $WikiVersion." }
}

& git -C $Destination apply --check $patchPath
if ($LASTEXITCODE -ne 0) {
  throw "The navigation patch does not apply cleanly to Wiki.js $WikiVersion. Stop and review the upstream changes."
}

& git -C $Destination apply $patchPath
if ($LASTEXITCODE -ne 0) { throw 'Unable to apply the navigation patch.' }

$actualCommit = (& git -C $Destination rev-parse HEAD).Trim()
if (-not [string]::IsNullOrWhiteSpace($WikiCommit) -and $actualCommit -ne $WikiCommit) {
  throw "Wiki.js $WikiVersion resolved to $actualCommit, expected pinned commit $WikiCommit."
}

Write-Host "Prepared Wiki.js $WikiVersion ($actualCommit) at $Destination"
