{ inputs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

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
