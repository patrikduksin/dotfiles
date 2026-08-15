#!/bin/bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  exit 0
fi

# Disable the Spotlight shortcuts so Raycast can own Command-Space.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 '{ enabled = 0; }'

# Keep only the U.S. and RussianWin keyboard layouts, with U.S. selected.
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string 'com.apple.keylayout.US'
defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
  '{ InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 0; "KeyboardLayout Name" = "U.S."; }' \
  '{ InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 19458; "KeyboardLayout Name" = "RussianWin"; }'
defaults write com.apple.HIToolbox AppleSelectedInputSources -array \
  '{ InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 0; "KeyboardLayout Name" = "U.S."; }'

# Enable Touch ID authentication for sudo using Apple's local override file.
if [[ ! -f /etc/pam.d/sudo_local ]] && [[ -f /etc/pam.d/sudo_local.template ]]; then
  sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
fi

if [[ -f /etc/pam.d/sudo_local ]] && ! grep -Eq '^[[:space:]]*auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so' /etc/pam.d/sudo_local; then
  sudo sed -i '' -E 's|^#[[:space:]]*(auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so.*)$|\1|' /etc/pam.d/sudo_local
fi

killall cfprefsd Dock Finder SystemUIServer 2>/dev/null || true
