$ErrorActionPreference = "Stop"

$fontName = "JetBrainsMono Nerd Font Mono"
$fontPackage = "DEVCOM.JetBrainsMonoNerdFont"
$terminalFamily = "Microsoft.WindowsTerminal_8wekyb3d8bbwe"
$settingsPath = Join-Path $env:LOCALAPPDATA "Packages\$terminalFamily\LocalState\settings.json"

$fontKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts",
    "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
)

$fontInstalled = $false
foreach ($fontKey in $fontKeys) {
    if (Test-Path -LiteralPath $fontKey) {
        $match = (Get-ItemProperty -LiteralPath $fontKey).PSObject.Properties |
            Where-Object { $_.Name -like "JetBrainsMono NFM Regular*" }
        if ($match) {
            $fontInstalled = $true
            break
        }
    }
}

if (-not $fontInstalled) {
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        throw "winget is required to install $fontName."
    }
    winget.exe install --id $fontPackage --exact --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "Nerd Font installation failed with exit code $LASTEXITCODE."
    }
}

if (-not (Test-Path -LiteralPath $settingsPath)) {
    throw "Windows Terminal settings were not found at $settingsPath."
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $settingsPath -Destination "$settingsPath.backup-$timestamp"

$settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
$font = [pscustomobject]@{
    face = $fontName
    size = 12
}
$settings.profiles.defaults | Add-Member -NotePropertyName font -NotePropertyValue $font -Force
$settings | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $settingsPath -Encoding utf8

Write-Host "Windows Terminal now uses $fontName."
Write-Host "Close every Windows Terminal window and open it again to refresh the icons."
