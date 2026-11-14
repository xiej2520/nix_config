#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: linux-fhs COMMAND [ARG...]

Run a command in an FHS compatibility environment with Nix-provided libraries.
Does not modify the executable. Requires no system configuration changes.

Examples:
  linux-fhs ./app arg1
  linux-fhs bash
EOF
}

if [[ $# -eq 0 ]]; then
  usage >&2
  exit 2
fi

case "$1" in
  -h|--help) usage; exit 0 ;;
esac

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
runtime=$(nix build --file "$script_dir/linux-fhs.nix" \
  --no-link --print-out-paths)

exec "$runtime/bin/steam-run" "$@"
