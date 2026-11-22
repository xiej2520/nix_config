# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  iosevka-legible = pkgs.callPackage ./iosevka-legible { };
  llama-cpp-custom = pkgs.callPackage ./llama-cpp-custom.nix { };
  llama-swap-custom = pkgs.callPackage ./llama-swap-custom.nix { };
}
