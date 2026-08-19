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
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jackyxie2520@outlook.com";
  };
}