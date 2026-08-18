{ lib, pkgs, config, ... }:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;

  domainName = "xiej.dev";
in
{
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts.${domainName} = {
      forceSSL = true;
      enableACME = true;

      # add something at /var/www/${domainName}/index.html
      root = "/var/www/${domainName}";
    };

    # Forgejo
    virtualHosts."git.${domainName}" = {
      forceSSL = true;
      enableACME = true;

      extraConfig = ''
        client_max_body_size 512M;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jackyxie2520@outlook.com";
  };


  services.forgejo = {
    enable = true;
    database.type = "postgres";

    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "git.${domainName}";

        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${srv.DOMAIN}/";
        HTTP_PORT = 3000;

        SSH_PORT = 22;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      # Sending emails is completely optional
      # You can send a test email from the web UI at:
      # Profile Picture > Site Administration > Configuration >  Mailer Configuration
      mailer = {
        ENABLED = false;
        SMTP_ADDR = "mail.example.com";
        FROM = "noreply@${srv.DOMAIN}";
        USER = "noreply@${srv.DOMAIN}";
      };

      #"cron.update_mirrors".SCHEDULE = "@every 8h";
      #mirror = {
      #  DEFAULT_INTERVAL = "8h";
      #  MIN_INTERVAL = "10m";
      #};

      ui = {
        DEFAULT_THEME = "custom";
        THEMES = "forgejo-auto,forgejo-light,forgejo-dark,custom";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d '${config.services.forgejo.customDir}/templates' 0750 forgejo forgejo - -"
    "d '${config.services.forgejo.customDir}/public/assets/css' 0750 forgejo forgejo - -"

    "L+ '${config.services.forgejo.customDir}/templates/home.tmpl' - - - - ${./home.tmpl}"
    "L+ '${config.services.forgejo.customDir}/public/assets/css/theme-custom.css' - - - - ${./theme-custom.css}"
  ];
  # sudo systemd-tmpfiles --create
  # sudo systemctl restart forgejo

  # read -s -p "Forgejo password: " FORGEJO_PASSWORD
  # echo
  # sudo systemctl show forgejo -p ExecStart --value
  #sudo -u forgejo <forgejo path>
  #  --work-path /var/lib/forgejo \
  #  admin user create \
  #  --username <username> \
  #  --email <email> \
  #  --admin
  #  --password "$FORGEJO_PASSWORD"
  #
}
