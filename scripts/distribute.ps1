param(
  [Parameter(Mandatory=$true)][string]$AppId,
  [Parameter(Mandatory=$true)][string]$Tester1,
  [Parameter(Mandatory=$true)][string]$Tester2
)

flutter build apk --release
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk `
  --app $AppId `
  --testers "$Tester1,$Tester2" `
  --release-notes "ConnectMe V1.0 beta — capstone delivery"
