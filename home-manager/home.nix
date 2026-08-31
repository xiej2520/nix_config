# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  # inputs,
  # outputs,
  # lib,
  config,
  pkgs,
  ...
}:
let
  cli = import ./cli { inherit pkgs; };
  desktop = import ./desktop { inherit pkgs; };

  dotfiles = /home/xiej/nix_config/home-manager/dotfiles;
  # symlink = name: config.lib.file.mkOutOfStoreSymlink (dotfiles + name);

  # set "dev.containers.dockerPath": "podman-remote-vscode" in vscode settings.json,
  # and systemctl --user enable --now podman.socket
  podmanRemote = pkgs.writeShellScriptBin "podman-remote-vscode" ''
    exec podman \
      --remote \
      --url "unix://$XDG_RUNTIME_DIR/podman/podman.sock" \
      "$@"
  '';
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./common.nix
  ];
  _module.args = {
    inherit dotfiles;
  };

  nixpkgs = {
    config = {
      android_sdk.accept_license = true;
    };
  };

  home.stateVersion = "26.05";

  home.packages =
    cli.cliPackages
    ++ cli.cliPackagesExtra
    ++ desktop.desktopPackages
    ++ desktop.desktopPlusPackages
    ++ desktop.kdeConfigPackages
    ++ desktop.devPackages
    ++ desktop.devPlusPackages
    ++ desktop.gamePackages
    ++ desktop.fontPackages
    ++ desktop.minecraftPackages
    ++ desktop.miscPackages
    ++ (with pkgs; [
      podmanRemote
      vscodium-fhs
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
