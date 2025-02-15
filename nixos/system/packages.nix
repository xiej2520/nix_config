{ config, pkgs, outputs, ... }:
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
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  services.flatpak.enable = true;
	
  ### Programs (with configuration options)

  programs.firefox.enable = true;
  # steam must be installed system-wide
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    cmake
    distrobox
    git
    gdb
    gcc
    gnumake
    gparted
    lsof
    neovim
    nodejs
    (python3.withPackages (python-pkgs: with python-pkgs; [
      numpy
      pandas
      requests
      venvShellHook
    ]))
    vscode.fhs
    wget
  ] #++ (with kdePackages; [
    #  extra-cmake-modules
    #  qtdeclarative
    #  qtquick3d
    #  qttools
    #  qtwayland
    #])
    ++ ([
      cargo
      rustc
      gcc
    ])
  ;

}
