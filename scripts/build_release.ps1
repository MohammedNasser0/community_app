$ErrorActionPreference = 'Stop'
flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'Dependency resolution failed.' }
dart format lib test
if ($LASTEXITCODE -ne 0) { throw 'Formatting failed.' }
flutter analyze
if ($LASTEXITCODE -ne 0) { throw 'Analysis failed.' }
flutter test
if ($LASTEXITCODE -ne 0) { throw 'Tests failed.' }
flutter build apk --release
if ($LASTEXITCODE -ne 0) { throw 'Release build failed.' }
Write-Host 'Release APK: build/app/outputs/flutter-apk/app-release.apk'
