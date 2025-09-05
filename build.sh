#!/bin/sh

if [ -z "$HOST" ]; then
  read -p "HOST is not set. Please enter the desired system name (press Enter to use $(hostname)): " input_host
  HOST="${input_host:-$(hostname)}"
fi
echo "Using HOST: '$HOST'"

if [ -z "$USER" ]; then
  read -p "USER is not set. Please enter the username (press Enter to use the $(whoami)): " input_user
  USER="${input_user:-$(whoami)}"
fi
echo "Using USER: '$USER'"

echo "Rebuilding and activating nixos"
sudo HOST=$HOST nixos-rebuild switch --flake .#$HOST --show-trace # --impure
echo "Rebuilding and activating home-manager"
home-manager switch --flake .#$USER@$HOST #--impure
