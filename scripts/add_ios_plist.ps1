param(
    [Parameter(Mandatory=$false)]
    [string]$SourcePath
)

# Copies a GoogleService-Info.plist into ios/Runner and prints next steps.
# Usage: .\add_ios_plist.ps1 -SourcePath C:\path\to\GoogleService-Info.plist

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$destDir = Join-Path $projectRoot "..\ios\Runner"
$destDir = (Resolve-Path $destDir).ProviderPath
$destPath = Join-Path $destDir "GoogleService-Info.plist"

if (-not $SourcePath) {
    Write-Host "Please provide the source path to your GoogleService-Info.plist"
    Write-Host "Usage: .\add_ios_plist.ps1 -SourcePath C:\path\to\GoogleService-Info.plist"
    exit 1
}

if (-not (Test-Path $SourcePath)) {
    Write-Host "Source file not found: $SourcePath"
    exit 1
}

Copy-Item -Path $SourcePath -Destination $destPath -Force
Write-Host "Copied GoogleService-Info.plist to: $destPath"
Write-Host "Next steps:"
Write-Host "  1) Open Xcode: open ios/Runner.xcworkspace"
Write-Host "  2) In Xcode add the file to the Runner target (if not already included)."
Write-Host "  3) Ensure iOS deployment target is >= 11.0 (Project > Runner > Info > iOS Deployment Target)."
Write-Host "  4) Run 'flutter clean' then 'flutter run' to trigger pod install/build."
Write-Host "If you prefer, you can also run 'flutterfire configure' to regenerate firebase config files (requires FlutterFire CLI)."}