# home-manager configuration file, replaces ~/.config/nixpkgs/home.nix
{
  config,
  pkgs,
  ...
}:
let
  cli = import ./cli { inherit pkgs; };
  desktop = import ./desktop { inherit pkgs; };

  dotfiles = /home/xiej/nix_config/home-manager/dotfiles;
  symlink = name: config.lib.file.mkOutOfStoreSymlink (dotfiles + name);
in
{
  imports = [
    # modules from this flake: modules/home-manager

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./common.nix
  ];

  _module.args = {
    inherit dotfiles;
  };

  home.stateVersion = "26.05";

  home.packages =
    cli.cliPackages
    ++ cli.cliPackagesExtra
    ++ desktop.desktopPackages
    ++ desktop.kdeConfigPackages
    ++ desktop.devPackages
    ++ desktop.fontPackages
    ++ desktop.minecraftPackages
    ++ (with pkgs; [
      obs-studio
      unstable.typst

      xwayland-satellite
    ]);

  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;
    # launch zed . from a nix develop to use project-specific language servers
    extraPackages = with pkgs; [
      nil
      nixd
      nixfmt
      rust-analyzer
      jdt-language-server
    ];
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

	xdg.configFile."niri/config.kdl".source = symlink /config.kdl;
  # gui-configured settings in ~/.local/state/noctalia/settings.toml
  xdg.configFile."noctalia/settings.toml".source = symlink /noctalia_settings.toml;

  services.udiskie = {
    enable = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
    };
  };
}
