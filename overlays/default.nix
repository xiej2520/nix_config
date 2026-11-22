# This file defines overlays to globally modify derivations in nixpkgs
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    cubiomes-viewer = prev.cubiomes-viewer.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ./cubiomes-viewer-patch/0001-fix-mapview-drag-on-linux-by-lowering-threshold-for-.patch
      ];
    });

    klassy = prev.klassy.overrideAttrs (old: {
      version = "6.7.3";
      src = old.src.override {
        tag = "v6.7.3";
        hash = "sha256-Uk4uB1dzm4aA6pHeYTgvFBf5CVbAsxoWYJYGkCzxGfY=";
      };
      # Make the Klassy Plasma styles follow the system color scheme like Breeze
      postInstall = (old.postInstall or "") + ''
        rm $out/share/plasma/desktoptheme/klassy-{dark,light}/colors
      '';
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
