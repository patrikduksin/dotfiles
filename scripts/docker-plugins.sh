#!/bin/bash
set -euo pipefail

docker_config_dir="${DOCKER_CONFIG:-$HOME/.docker}"
plugin_dir="$docker_config_dir/cli-plugins"
brew_bin="$(command -v brew)"
brew_prefix="$($brew_bin --prefix)"

mkdir -p "$plugin_dir"

for plugin in docker-compose docker-buildx; do
  plugin_bin="$brew_prefix/opt/$plugin/bin/$plugin"
  if [[ -x "$plugin_bin" ]]; then
    ln -sfn "$plugin_bin" "$plugin_dir/$plugin"
  fi
done
