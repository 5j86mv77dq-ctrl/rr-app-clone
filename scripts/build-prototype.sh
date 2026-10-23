#!/bin/bash
# Builds Prototype.app from prototype-app/ and places it at the repo root (gitignored).
set -euo pipefail
cd "$(dirname "$0")/../prototype-app"

swift build -c release

APP="../Prototype.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/Prototype "$APP/Contents/MacOS/Prototype"
cp AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

cat > "$APP/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>Prototype</string>
  <key>CFBundleDisplayName</key><string>Prototype</string>
  <key>CFBundleIdentifier</key><string>com.peteratkinson.prototype</string>
  <key>CFBundleExecutable</key><string>Prototype</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsLocalNetworking</key><true/>
  </dict>
</dict>
</plist>
PLIST

codesign --force --sign - "$APP"
echo "Built: $(cd .. && pwd)/Prototype.app"
