{ lib, pkgs, config, domainName, ... }:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  imports = [
  ];

  virtualisation.oci-containers = {
    backend = "podman";

    containers.memos = {
      image = "neosmemo/memos:26.11.0";

      # run PID 1 as user, not root
      podman.user = "xiej";
      user = "10001:10001";

      # host user appears as 10001:10001 in container
      extraOptions = [
        "--userns=keep-id:uid=10001,gid=10001"
      ];

      ports = [
        "127.0.0.1:5230:5230"
      ];

      volumes = [
        "/var/lib/memos:/var/opt/memos"

        # source in nix config, dest memos reads every *.json in /etc/memos/config
        "${./memos-config.json}:/etc/memos/config/instance.json:ro"
      ];

      environment = {
        MEMOS_PORT = "5230";
        MEMOS_DRIVER = "sqlite";
        MEMOS_DATA = "/var/opt/memos";
      };
    };
  };

  services.nginx.virtualHosts."memos.${domainName}" = {
    forceSSL = true;
    enableACME = true;

    extraConfig = ''
      client_max_body_size 1G;
    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:5230";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_request_buffering off;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
      '';
    };
  };

  systemd.tmpfiles.rules = [
    # allow user to write to /var/lib/memos, run rootless container under user
    "d /var/lib/memos 0750 xiej users -"
  ];

}
