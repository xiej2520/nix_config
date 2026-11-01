{ inputs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    # only launch noctalia with niri, alternatively add to niri's config.kdl
    # systemctl --user restart noctalia
    systemd = {
      enable = true;
      target = "niri.service";
    };
    #settings = { };
    #settings = ./noctalia-settings.json;
    # ~/.local/state/noctalia/settings.toml
    # ~/.config/noctalia/settings.toml
    # ~/.config/noctalia/palettes/custom.json
  };
}
