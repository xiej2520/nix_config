# Usage:
#   out=$(nix build --file linux-run.nix --no-link --print-out-paths)
#   "$out/bin/linux-run" ./path/to/program [args...]
# Permanently modifies the executable's ELF interpreter.
{ pkgs ? import <nixpkgs> {} }:
pkgs.writeShellScriptBin "linux-run" ''
  set -euo pipefail

  if [ "$#" -eq 0 ]; then
    echo "Usage: linux-run EXECUTABLE [ARG...]" >&2
    exit 2
  fi

  case "$1" in
    -h|--help)
      echo "Usage: linux-run EXECUTABLE [ARG...]"
      echo "Permanently modifies the executable's ELF interpreter."
      exit 0
      ;;
  esac

  executable=$(${pkgs.coreutils}/bin/realpath -- "$1")
  shift

  ${pkgs.patchelf}/bin/patchelf \
    --set-interpreter "${pkgs.stdenv.cc.bintools.dynamicLinker}" \
    "$executable"

  export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (
    import ./linux-libraries.nix pkgs
  )}:/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

  exec "$executable" "$@"
''
