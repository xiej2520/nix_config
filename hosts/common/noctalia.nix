{ inputs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  # noctalia-shell ipc call state all > dotfiles/noctalia-state.json
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
    #settings = { };
    # this may also be a string or a path to a JSON file.
    #settings = ./noctalia-settings.json;
    # ~/.config/noctalia/settings.json
  };
}
