#!/bin/bash
set -euo pipefail

# Dedicated npm:* tools should win over packages installed into Node itself.
for node_npm in "$HOME"/.local/share/mise/installs/node/*/bin/npm; do
  [[ -x "$node_npm" ]] || continue
  "$node_npm" uninstall -g \
    @openai/codex \
    @anthropic-ai/claude-code \
    eas-cli \
    agent-browser \
    @earendil-works/pi-coding-agent \
    opencode-ai \
    >/dev/null 2>&1 || true
done
