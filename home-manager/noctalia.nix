{ pkgs, inputs, ... }:
{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # noctalia-shell ipc call state all > dotfiles/noctalia-settings.json
  programs.noctalia-shell = {
    enable = true;
    #settings = {
    #  bar = {
    #    density = "compact";
    #    position = "left";
    #    showCapsule = false;
    #    widgets = {
    #      left = [
    #        {
    #          id = "ControlCenter";
    #          useDistroLogo = true;
    #        }
    #        {
    #          id = "Network";
    #        }
    #        {
    #          id = "Bluetooth";
    #        }
    #      ];
    #      center = [
    #        {
    #          hideUnoccupied = false;
    #          id = "Workspace";
    #          labelMode = "none";
    #        }
    #      ];
    #      right = [
    #        {
    #          alwaysShowPercentage = false;
    #          id = "Battery";
    #          warningThreshold = 30;
    #        }
    #        {
    #          formatHorizontal = "HH:mm";
    #          formatVertical = "HH mm";
    #          id = "Clock";
    #          useMonospacedFont = true;
    #          usePrimaryColor = true;
    #        }
    #      ];
    #    };
    #  };
    #  colorSchemes.predefinedScheme = "Monochrome";
    #};
    # this may also be a string or a path to a JSON file.
    #settings = ./noctalia.json;
  };
}