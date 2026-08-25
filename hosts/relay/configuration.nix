{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  hostname = "relay";
  username = "xiej";
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhB/tgSMKMu1xaTPUr/RqhsQE81z3hJ7SOggatN259M jackyxie2520@outlook.com
";
  locale = "en_US.UTF-8";
  timezone = "America/Chicago";

  domainName = "xiej.dev";
in
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix

    ./forgejo
    ./nginx
  ];

  _module.args = {
    inherit  domainName;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
      };
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  environment.systemPackages = with pkgs; [
    curl
    git
    jdk25_headless # minecraft server
    jujutsu
    vim # not vim-full
    wget
    zellij
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = timezone;
  i18n.defaultLocale = locale;

  systemd.targets.multi-user.enable = true;
  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Disable autologin.
  services.getty.autologinUser = null;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    8100 # bluemap
    25565 # minecraft server
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [ sshKey ];
    };
  };

  # Disable documentation for minimal install.
  documentation.enable = false;

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  # https://nixos.org/manual/nixos/stable/release-notes
  system.stateVersion = "26.05"; # Did you read the comment?
}
