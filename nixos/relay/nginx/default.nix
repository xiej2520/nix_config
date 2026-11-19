{ domainName, inputs, pkgs, ... }:
let
  pkgsSmall = inputs.nixpkgs-2605-small.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./goaccess.nix
  ];

  services.nginx = {
    enable = true;
    package = pkgsSmall.nginx;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts.${domainName} = {
      forceSSL = true;
      enableACME = true;

      # add something at /var/www/${domainName}/index.html
      #root = ./site;
      root = "/var/www/${domainName}";

      # proxy to bluemap
      locations."/map/" = {
        proxyPass = "http://127.0.0.1:8100/";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/www/${domainName} 0755 xiej users -"
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "jackyxie2520@outlook.com";
  };
}