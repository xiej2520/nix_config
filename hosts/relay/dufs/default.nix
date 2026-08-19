{ domainName, ... }:
{

  virtualisation.oci-containers = {
    backend = "podman";

    containers.dufs = {
      image = "sigoden/dufs:v0.46.0";

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
    "d /srv/dufs 0750 root root -"
  ];
}
