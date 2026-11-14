# Usage:
#   out=$(nix build --file linux-fhs.nix --no-link --print-out-paths)
#   "$out/bin/steam-run" ./path/to/program [args...]
#   "$out/bin/steam-run" bash
# Runs in an FHS environment without modifying the executable.
{ pkgs ? import <nixpkgs> {} }:
(pkgs.steam.override {
  extraLibraries = p: import ./linux-libraries.nix p;
  privateTmp = false;
}).run-free
