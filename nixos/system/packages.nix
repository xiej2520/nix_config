{ config, pkgs, outputs, ... }:
let
  basePackages = (with pkgs; [
    bat
    bottom
    curl
    difftastic
    erdtree
    fd
    git
    lsof
    ripgrep
    tree
    vim
    wget
  ]);
  kdePackages = (with pkgs.kdePackages; [
    sddm-kcm
  ]);
  ### Programs (with configuration options)
  programs = {
    firefox.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # steam must be installed system-wide
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  # usused, use dev environment normally
  #devPackages = with pkgs; [
  #  cargo
  #  rustc
  #  cmake
  #  gcc
  #  gdb
  #  gnumake
  #];
  # minimal python3 install for scripting
  pythonPackages = [(
    pkgs.python3.withPackages (
      python-pkgs: with python-pkgs; [
        numpy
        pandas
        requests
        venvShellHook
      ]
    )
  )];
in
{
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
    };
  };

  services.flatpak.enable = true;

  programs = programs;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Packages installed in system profile
  environment.systemPackages =
    basePackages
    ++ kdePackages
    ++ pythonPackages
    ++ (with pkgs; [
      # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      bluez
      distrobox
      devenv
      gparted
    ]);
  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "twitter-color-emoji" ];
        monospace = [ "iA-Writer" ];
        #sansSerif = ["Lexend Deca"];
      };
      useEmbeddedBitmaps = true;
    };
    packages = with pkgs; [
      nerd-fonts.im-writing # default, no ligatures
      #nerd-fonts.FragmentMono # wider, less serifs
      #nerd-fonts.Maple        # comic-ish, widths feel off
      monocraft # nerd-fonts.Monocraft
      nerd-fonts.monaspace # Neon
      twitter-color-emoji
    ];
  };

  environment.variables.EDITOR = "nvim";

}
