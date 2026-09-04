{ inputs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
    #settings = { };
    #settings = ./noctalia-settings.json;
    # ~/.local/state/noctalia/settings.toml
    # ~/.config/noctalia/settings.toml
  };
}
