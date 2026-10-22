{ lib, pkgs, ... }:
let
  generateReport = pkgs.writeShellApplication {
    name = "goaccess-report";
    runtimeInputs = with pkgs; [ coreutils gawk gzip goaccess ];
    text = ''
      export LC_ALL=C

      output=$1
      report_date=''${2:-}
      log_directory=''${3:-/var/log/nginx}

      input=$(mktemp)
      trap 'rm -f -- "$input"' EXIT

      # Read current and rotated logs, ignore unmatched rotation globs
      shopt -s nullglob
      for log in "$log_directory"/access.log "$log_directory"/access.log.*; do
        [[ -f "$log" ]] || continue
        case "$log" in
          *.gz) gzip -cd -- "$log" ;;
          *) cat -- "$log" ;;
        esac
      done | awk -v day="$report_date" 'day == "" || index($4, "[" day ":") == 1' > "$input"

      if [[ ! -s "$input" ]]; then
        echo "No matching access log entries; skipping $output"
        exit 0
      fi

      mkdir -p -- "$(dirname -- "$output")"
      goaccess "$input" --log-format=COMBINED --output="$output"
    '';
  };

  reportService = description: script: {
    inherit description script;
    startAt = "daily";
    path = [ pkgs.coreutils ];
    serviceConfig = {
      Type = "oneshot";
      # same `User` name in both services so they share one dynamic uid and the state dir.
      DynamicUser = true;
      User = "goaccess";
      SupplementaryGroups = [ "nginx" ];
      StateDirectory = "goaccess";
      PrivateNetwork = true;
    };
  };
in
{
  # Generate reports now:
  #   sudo systemctl start goaccess-daily.service goaccess-cumulative.service
  # Daily: /var/lib/goaccess/daily/YYYY-MM-DD.html
  # Cumulative: /var/lib/goaccess/cumulative.html
  #
  # ssh relay 'sudo cat /var/lib/goaccess/cumulative.html' > goaccess.html
  # xdg-open goaccess.html
  #
  # sudo journalctl -u goaccess-daily.service -u goaccess-cumulative.service -n 50 --no-pager
  environment.systemPackages = [
    pkgs.goaccess
  ];

  systemd.services.goaccess-daily = reportService
    "Generate GoAccess report for the previous calendar day"
    ''
      export LC_ALL=C
      read -r report_date report_name < <(date --date=yesterday '+%d/%b/%Y %F')
      ${generateReport}/bin/goaccess-report \
        "/var/lib/goaccess/daily/$report_name.html" "$report_date"
    '';
  # Generate a cumulative report from all retained Nginx logs
  systemd.services.goaccess-cumulative = reportService
    "Generate cumulative GoAccess report"
    ''
      ${generateReport}/bin/goaccess-report /var/lib/goaccess/cumulative.html
    '';

  systemd.timers = lib.genAttrs [ "goaccess-daily" "goaccess-cumulative" ] (_: {
    timerConfig.Persistent = true;
  });
}
