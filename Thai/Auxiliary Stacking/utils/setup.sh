#!/bin/zsh
# Sets up XLE with native macOS Aqua Tk i.e. no XQuartz required.
# Run once from the XLE directory: ./setup.sh

set -e

XLEDIR="$(cd "$(dirname "$0")" && pwd)"

# Build XLE.app bundle

APPDIR="$XLEDIR/XLE.app"

mkdir -p "$APPDIR/Contents/MacOS"
mkdir -p "$APPDIR/Contents/Resources"

[[ -f "$XLEDIR/XLE.icns" ]] && cp "$XLEDIR/XLE.icns" "$APPDIR/Contents/Resources/XLE.icns"

cat > "$APPDIR/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>XLE</string>
    <key>CFBundleDisplayName</key>
    <string>XLE</string>
    <key>CFBundleExecutable</key>
    <string>XLE</string>
    <key>CFBundleIdentifier</key>
    <string>com.parc.xle</string>
    <key>CFBundleIconFile</key>
    <string>XLE</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleVersion</key>
    <string>2017.09.25</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSRequiresAquaSystemAppearance</key>
    <true/>
</dict>
</plist>
PLIST

# Copy the actual Mach-O binary inside the bundle.
# The CFBundleExecutable ("XLE") is the launcher script below; it execs
# XLE-bin which IS inside Contents/MacOS/ so macOS properly associates the
# running process with the bundle and applies NSRequiresAquaSystemAppearance.
cp "$XLEDIR/XLE" "$APPDIR/Contents/MacOS/XLE-bin"

# Copy Aqua Tcl/Tk dylibs alongside XLE-bin so @loader_path/tcltk/ resolves.
rm -rf "$APPDIR/Contents/MacOS/tcltk"
cp -r "$XLEDIR/tcltk" "$APPDIR/Contents/MacOS/tcltk"

# Launcher: sets XLEPATH to the folder containing xle.tcl, then execs the
# real binary that lives INSIDE the bundle.
cat > "$APPDIR/Contents/MacOS/XLE" <<'LAUNCHER'
#!/bin/zsh
BUNDLE_MACOS="$(cd "$(dirname "$0")" && pwd)"
XLEDIR="$(cd "$BUNDLE_MACOS/../../.." && pwd)"
export XLEPATH="$XLEDIR"
export DYLD_LIBRARY_PATH="$XLEDIR:${DYLD_LIBRARY_PATH}"
export TCL_LIBRARY="$XLEDIR/tcl8.6"
export TK_LIBRARY="$XLEDIR/tk8.6-aqua"
exec "$BUNDLE_MACOS/XLE-bin" "$@"
LAUNCHER
chmod +x "$APPDIR/Contents/MacOS/XLE"

# Lets macOS trust the bundle's appearance settings
codesign --force --deep -s - "$APPDIR" 2>/dev/null && echo "Bundle codesigned (ad-hoc)." || echo "codesign unavailable — skipping."

echo "XLE.app built."

# Belt-and-suspenders: also write to defaults database
defaults write com.parc.xle NSRequiresAquaSystemAppearance -bool true

# Write env vars to .zshrc

ZSHRC="$HOME/.zshrc"

if [[ ! -f "$ZSHRC" ]]; then
  echo "# ~/.zshrc created by setup.sh" > "$ZSHRC"
fi

if grep -q "XLEPATH.*$XLEDIR" "$ZSHRC" 2>/dev/null; then
  echo "XLE already configured in $ZSHRC — skipping."
else
  echo "Adding XLE configuration to $ZSHRC..."
  cat >> "$ZSHRC" <<EOF

# XLE (added by setup.sh)
export XLEPATH="$XLEDIR"
export PATH="\${XLEPATH}:\${PATH}"
export LD_LIBRARY_PATH=${XLEPATH}/lib:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH="\${XLEPATH}:\${XLEPATH}/tcltk:\${DYLD_LIBRARY_PATH}"
export TCL_LIBRARY="\${XLEPATH}/tcl8.6"
export TCLLIBPATH="\${XLEPATH}/tcl8.6"
export TK_LIBRARY="\${XLEPATH}/tk8.6-aqua"
export TKLIBPATH="\${XLEPATH}/tk8.6-aqua"
EOF
  echo "Done. Run:  source ~/.zshrc"
fi

echo ""
echo "Verify with:  XLE -version"
echo "Or double-click XLE.app in Finder."