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
      systemd-boot.enable = false;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
      #efi.efiSysMountPoint = "/boot";
      timeout = 30;
    };
    supportedFilesystems = [ "ntfs" ];
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
    graphics = {
      # includes OpenGL, Vulkan, VA-API drivers
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        #
      ];
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
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
      vim
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
    displayManager.enable = true;
    displayManager.cosmic-greeter = {
      enable = lib.mkDefault true;
    };
    earlyoom.enable = true;
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    power-profiles-daemon.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false;

    xserver.videoDrivers = [ "nvidia" ];
    upower.enable = true;
  };

  networking = {
    hostName = "WORKING-LAPTOP";
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
    ../common/niri.nix
    ../common/cosmic.nix
  ];

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        # STOP OOM
        cores = 16;
        max-jobs = 4;
      };
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
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

  time.timeZone = "America/Chicago";
  # Fix Windows time
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.systemPackages =
    basePackages
    ++ (with pkgs; [
      gparted
      nvidia-vaapi-driver
      wl-clipboard-rs
    ]);
  environment.variables.EDITOR = "nvim";

  xdg.portal.wlr.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  users.groups.libvirtd.members = [ "xiej" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.users = {
    xiej = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [
        "kvm"
        "networkmanager"
        "wheel"
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11"; # Did you read the comment?
}
