# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cli = import ./cli { inherit pkgs; };
  desktop = import ./desktop { inherit pkgs; };

  symlink = name: config.lib.file.mkOutOfStoreSymlink name;
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };

  home = {
    username = "xiej";
    homeDirectory = "/home/xiej";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  home.packages =
    cli.cliPackages
    ++ desktop.desktopPackages
    ++ desktop.desktopPlusPackages
    ++ desktop.kdeConfigPackages
    ++ desktop.devPackages
    ++ desktop.devPlusPackages
    ++ desktop.gamePackages
    ++ desktop.fontPackages
    ++ desktop.minecraftPackages
    ++ desktop.miscPackages;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    initExtra = ''
      export PS1="''${PS1//\\u/\$SHLVL:\\u}"
      export PYTHONSTARTUP=~/.config/startup.py
    '';
  };
  home.file.".config/startup.py".source = symlink ./startup.py;

  #programs.git = {
  #  enable = true;
  #  userEmail = "jackyxie2520@outlook.com";
  #  userName = "xiej2520";
  #};
  home.file.".gitconfig".source = symlink ./.gitconfig;
  home.file.".gitignore".source = symlink ./.gitignore;

  programs.neovim.enable = true;
  # symlink configuration, use git subtree since submodules won't get copied
  home.file.".config/nvim".source = symlink ./nvim_config/nvim;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.java = {
    enable = true;
    #package = pkgs.jdk23.overrideAttrs (old: {
    #  enableJavaFX = true;
    #});
    package = pkgs.jdk25.overrideAttrs (old: {
      enableJavaFX = true;
      # https://github.com/NixOS/nixpkgs/issues/412283#issuecomment-3325887652
      buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];
      postFixup = ''
        wrapProgram $out/bin/java \
          --add-flags "--upgrade-module-path ${pkgs.openjfx25}/lib"
        wrapProgram $out/bin/javac \
          --add-flags "--upgrade-module-path ${pkgs.openjfx25}/lib"
      '';
    });
  };

  services.kdeconnect.enable = true;

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "twitter-color-emoji" ];
        monospace = [ "iA-Writer" ];
        sansSerif = [ "Lexend Deca" ];
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # try to get newly installed programs to show up in KDE Application Launcher
  home.activation.linkDesktopApplications = {
    after = [
      "writeBoundary"
      "createXdgUserDirectories"
    ];
    before = [ ];
    data = ''
      rm -rf ${config.xdg.dataHome}/nix-desktop-files/applications
      mkdir -p ${config.xdg.dataHome}/nix-desktop-files/applications
      cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/nix-desktop-files/applications/
    '';
  };
  xdg.enable = true;
  xdg.systemDirs.data = [ "${config.xdg.dataHome}/nix-desktop-files" ];
}
