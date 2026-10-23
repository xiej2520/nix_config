#!/usr/bin/env bash
# Stops Forgejo, create backup (PostgreSQL database + /var/lib/forgejo), and restart
set -euo pipefail

BACKUP="$HOME/backup/forgejo-$(date +%F-%H%M%S)"
mkdir -p "$HOME/backup"
mkdir -m 700 "$BACKUP"

# Stop Forgejo, and start it again however the script exits
sudo systemctl stop forgejo.service
trap 'sudo systemctl start forgejo.service' EXIT

# Backup PostgreSQL database
sudo -u postgres pg_dump -Fc forgejo > "$BACKUP/database.dump"

# Archive Forgejo files
sudo tar --acls --xattrs --numeric-owner  -cpf - -C /var/lib forgejo  > "$BACKUP/files.tar"

sudo systemctl start forgejo.service
trap - EXIT

# Verify the backup files are readable
ls -lh "$BACKUP"
echo "database.dump: $(pg_restore --list "$BACKUP/database.dump" | wc -l) entries"
echo "files.tar: $(tar -tf "$BACKUP/files.tar" | wc -l) entries"

# Restore backup:
#   sudo systemctl stop forgejo.service
#   sudo mv /var/lib/forgejo /var/lib/forgejo.old
#   sudo tar --acls --xattrs --numeric-owner -xpf ~/backup/forgejo-<date>/files.tar -C /var/lib
#   sudo -u postgres dropdb forgejo
#   sudo -u postgres createdb -O forgejo forgejo
#   sudo -u postgres pg_restore --exit-on-error -d forgejo < ~/backup/forgejo-<date>/database.dump
#   sudo systemctl start forgejo.service
# Delete /var/lib/forgejo.old once Forgejo works.
