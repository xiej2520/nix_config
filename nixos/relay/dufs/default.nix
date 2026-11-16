{ domainName, ... }:
{
  # uid must be set for a rootless oci-container (XDG_RUNTIME_DIR=/run/user/<uid>)
  users.groups.dufs = { };
  users.users.dufs = {
    isSystemUser = true;
    uid = 990;
    group = "dufs";
    home = "/var/lib/dufs-container";
    createHome = true;
    homeMode = "0700";
    autoSubUidGidRange = true;
    linger = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";

    containers.dufs = {
      image = "sigoden/dufs:v0.47.0";

      # image has no USER, so container root maps to host user `dufs`
      podman.user = "dufs";

      ports = [
        "127.0.0.1:5000:5000"
      ];

      volumes = [
        "/srv/dufs:/data"
        # Create the private config file with the steps in ./dufs.yaml
        "/etc/dufs/dufs.yaml:/config/dufs.yaml:ro"
        "${./assets}:/assets:ro"
      ];

      cmd = [
        "/data"
        "--config"
        "/config/dufs.yaml"
        "--assets"
        "/assets"
      ];
    };
  };

  services.nginx.virtualHosts."files.${domainName}" = {
    forceSSL = true;
    enableACME = true;

    extraConfig = ''
      client_max_body_size 20G;
    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:5000";

      extraConfig = ''
        proxy_request_buffering off;

        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
        send_timeout 3600s;
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/dufs 0750 dufs dufs -"
  ];
}
