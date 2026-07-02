#!/bin/bash
# Patch Claude Code VS Code extension's webview CSS to use editor font
# instead of chat font, so the font matches the editor (Courier New Bold 16px).
# This runs once per machine via chezmoi run_once_.

set -euo pipefail

# Find the Claude Code extension directory (version-agnostic)
EXT_DIR=$(ls -d ~/.vscode-oss/extensions/anthropic.claude-code-*/webview 2>/dev/null || ls -d ~/.vscode/extensions/anthropic.claude-code-*/webview 2>/dev/null || true)

if [ -z "$EXT_DIR" ]; then
  echo "⚠ Claude Code extension not found, skipping patch"
  exit 0
fi

CSS_FILE="$EXT_DIR/index.css"
if [ ! -f "$CSS_FILE" ]; then
  echo "⚠ $CSS_FILE not found, skipping"
  exit 0
fi

# Check if already patched
if grep -q 'vscode-editor-font-size' "$CSS_FILE"; then
  echo "✓ Claude Code fonts already patched"
  exit 0
fi

# Apply patch
python3 -c "
import re, sys

css_file = sys.argv[1]
with open(css_file, 'r') as f:
    css = f.read()

new_css = re.sub(
    r'body\{[^}]*\}',
    'body{display:flex;overscroll-behavior:none;font-size:var(--vscode-editor-font-size,16px);font-family:var(--vscode-editor-font-family,monospace);font-weight:var(--vscode-editor-font-weight,normal);flex:1;max-width:100%;margin:0;padding:0}',
    css,
    count=1,
)

if new_css != css:
    with open(css_file, 'w') as f:
        f.write(new_css)
    print('✓ Patched Claude Code webview fonts')
else:
    print('⚠ Could not patch - body CSS format may have changed. Check manually.')
" "$CSS_FILE"
