#!/usr/bin/env bash
# Stops memos, create backup (SQLite database + local attachments in /var/lib/memos), and restart
set -euo pipefail

BACKUP="$HOME/backup/memos-$(date +%F-%H%M%S)"
mkdir -p "$HOME/backup"
mkdir -m 700 "$BACKUP"

# Stop memos, and start it again however the script exits
sudo systemctl stop podman-memos.service
trap 'sudo systemctl start podman-memos.service' EXIT

# Backup memos data (the redirect runs as you, so the backup is yours)
sudo tar --acls --xattrs --numeric-owner -cpf - -C /var/lib memos > "$BACKUP/files.tar"

sudo systemctl start podman-memos.service
trap - EXIT

# Verify the backup files are readable
ls -lh "$BACKUP"
echo "files.tar: $(tar -tf "$BACKUP/files.tar" | wc -l) entries"

# Check the database copy is readable
CHECK=$(mktemp -d)
trap 'rm -rf "$CHECK"' EXIT
tar -xf "$BACKUP/files.tar" -C "$CHECK" --wildcards 'memos/*.db*'
for db in "$CHECK"/memos/*.db; do
  echo "$(basename "$db"): $(nix shell nixpkgs#sqlite -c sqlite3 "$db" 'PRAGMA integrity_check;')"
done

# Restore backup (if rolling back, deploy old image tag first):
#   sudo systemctl stop podman-memos.service
#   sudo mv /var/lib/memos /var/lib/memos.old
#   sudo tar --acls --xattrs --numeric-owner -xpf ~/backup/memos-<date>/files.tar -C /var/lib
#   sudo systemctl start podman-memos.service
# Delete /var/lib/memos.old once memos works.
