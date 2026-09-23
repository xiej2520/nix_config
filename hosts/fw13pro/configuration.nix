{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl."kernel.sysrq" = 1; # Alt+SysRq+h
    kernel.sysctl."vm.swappiness" = 100; # equal swap and filesystem paging cost
    zswap = {
      enable = true;
      compressor = "zstd";
      maxPoolPercent = 20;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = "true";
        };
        Policy = {
          AutoEnable = "true";
        };
      };
    };
  };

  basePackages = (
    with pkgs;
    [
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
      vim-full
      wget
    ]
  );

  programs = {
    firefox.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    xwayland.enable = true;
    virt-manager.enable = true;
  };

  services = {
    # automatic-timezoned.enable = true;
    displayManager.enable = true;
    earlyoom.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # enable the kde plasma desktop environment.
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;

    power-profiles-daemon.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false;

    udisks2.enable = true;
    upower.enable = true;
  };

  services.syncthing = {
    enable = true;
    dataDir = "/home/xiej/Syncthing";
    openDefaultPorts = true;
    configDir = "/home/xiej/.config/syncthing";
    user = "xiej";
  };


  networking = {
    hostName = "FW13PRO";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [
        "virbr0" # virt-manager
      ];
    };
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "twitter-color-emoji" ];
        monospace = [ "iA-Writer" ];
      };
      useEmbeddedBitmaps = true;
    };
    packages = with pkgs; [
      nerd-fonts.im-writing
      iosevka
      monocraft
      twitter-color-emoji
    ];
  };

in
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    outputs.nixosModules.niri
    outputs.nixosModules.noctalia
  ];

  nix.settings = {
    # STOP OOM
    cores = 16;
    max-jobs = 4;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  inherit boot;
  inherit hardware;
  inherit programs;
  inherit services;
  inherit networking;
  inherit fonts;

  environment.systemPackages =
    basePackages
    ++ (with pkgs; [
      gparted # on niri: sudo -E gparted
      wl-clipboard-rs
    ]);
  environment.variables.EDITOR = "nvim";

  # xdg.portal.wlr.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
    }
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  users.groups.libvirtd.members = [ "xiej" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.users = {
    xiej = {
      isNormalUser = true;
      # openssh.authorizedKeys.keys = [ ];
      extraGroups = [
        "kvm"
        "networkmanager"
        "wheel"
      ];
    };
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  # https://nixos.org/manual/nixos/stable/release-notes
  system.stateVersion = "26.05"; # Did you read the comment?
}
