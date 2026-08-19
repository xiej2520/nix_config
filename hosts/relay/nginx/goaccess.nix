{ lib, pkgs, config, domainName, ... }:

{
  environment.systemPackages = [
    pkgs.goaccess
  ];

  # Persistent location for generated reports.
  systemd.tmpfiles.rules = [
    "d /var/lib/goaccess 0750 root root -"
    "d /var/lib/goaccess/daily 0750 root root -"
    "d /var/lib/goaccess/monthly 0750 root root -"
  ];

  systemd.services.goaccess-daily = {
    description = "Generate daily GoAccess report";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    script = ''
      mkdir -p /var/lib/goaccess/daily

      ${pkgs.goaccess}/bin/goaccess \
        /var/log/nginx/access.log \
        --log-format=COMBINED \
        --output="/var/lib/goaccess/daily/$(date +%F).html"
    '';
  };

  systemd.timers.goaccess-daily = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  # Generate a cumulative report from all retained Nginx logs.
  systemd.services.goaccess-cumulative = {
    description = "Generate cumulative GoAccess report";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    script = ''
      set -eu

      mkdir -p /var/lib/goaccess

      ${pkgs.goaccess}/bin/goaccess \
        /var/log/nginx/access.log \
        /var/log/nginx/access.log-*.gz \
        /var/log/nginx/access.log-*.log \
        --log-format=COMBINED \
        --output=/var/lib/goaccess/cumulative.html
    '';
  };

  systemd.timers.goaccess-cumulative = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
