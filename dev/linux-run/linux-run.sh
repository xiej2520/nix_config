#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: linux-run EXECUTABLE [ARG...]

Run a GNU/glibc executable with Nix-provided libraries.
Permanently modifies the executable's ELF interpreter; the file must be writable.

Examples:
  linux-run ./app arg1
  linux-run ./program --help
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
runtime=$(nix build --file "$script_dir/linux-run.nix" \
  --no-link --print-out-paths)

exec "$runtime/bin/linux-run" "$@"
