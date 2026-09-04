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
      image = "neosmemo/memos:0.30.0";

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

        # source in nix config, dest must be directly under /etc/secrets.
        "${./memos-instance-setting-general.json}:/etc/secrets/memos-instance-setting-general.json:ro"
      ];

      environment = {
        MEMOS_PORT = "5230";
        MEMOS_DRIVER = "sqlite";
        MEMOS_DATA = "/var/opt/memos";

        # Intentionally omitted:
        # MEMOS_INSTANCE_URL
        #
        # Leaving it unset makes the instance private,
        # so unauthenticated users are sent to the sign-in page.
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
