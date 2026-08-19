{ lib, pkgs, config, domainName, ... }:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  imports = [
    ./goaccess.nix
  ];

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts.${domainName} = {
      forceSSL = true;
      enableACME = true;

      # add something at /var/www/${domainName}/index.html
      root = "/var/www/${domainName}";

      # proxy to bluemap
      locations."/map/" = {
        proxyPass = "http://127.0.0.1:8100/";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };

    # Forgejo
    virtualHosts."git.${domainName}" = {
      forceSSL = true;
      enableACME = true;

      extraConfig = ''
        client_max_body_size 512M;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:3000/";

        # stop scraping without JS
        extraConfig = ''
          if ($http_user_agent ~* "git/|git-lfs/") {
            set $bypass_cookie 1;
          }

          if ($cookie_free_cookies = "1") {
            set $bypass_cookie 1;
          }

          if ($bypass_cookie != 1) {
            add_header Content-Type text/html always;
            return 418 '<h1>this site requires javascript to prevent spam scraping</h1><script>document.cookie = "free_cookies=1; Path=/;"; window.location.reload();</script>';
          }
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jackyxie2520@outlook.com";
  };
}