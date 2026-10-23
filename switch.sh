#!/usr/bin/env bash

os_only=false
user_only=false

case "${1:-}" in
--os-only) os_only=true ;;
--user-only) user_only=true ;;
-h | --help)
  echo "Usage: ./switch.sh [--os-only] [--user-only]"
  echo "  Default: switch NixOS and Home Manager."
  echo "  --os-only: switch NixOS only."
  echo "  --user-only: switch Home Manager only."
  echo "  HOST and USER chooses flake config."
  exit 0
  ;;
"") ;;
*)
  echo "Unknown option: $1. Use --help for usage." >&2
  exit 2
  ;;
esac
if [ "$#" -gt 1 ]; then
  echo "Too many arguments. Use --help for usage." >&2
  exit 2
fi

export NIX_CONFIG="experimental-features = nix-command flakes"

# generate /etc/nixos/{configuration.nix, hardware-configuration.nix}
# cp ~/etc/nixos/hardware-configuration ./hosts/<HOST>/hardware-configuration
# make sure to use right host

if [ -z "$HOST" ]; then
  read -r -p "HOST is not set. Please enter the desired system name (press Enter to use $(hostname)): " input_host
  HOST="${input_host:-$(hostname)}"
fi
echo "Using HOST: '$HOST'"

if [ -z "$USER" ]; then
  read -r -p "USER is not set. Please enter the username (press Enter to use the $(whoami)): " input_user
  USER="${input_user:-$(whoami)}"
fi
echo "Using USER: '$USER'"

if [ "$user_only" = false ]; then
  echo "Rebuilding and activating nixos"
  sudo HOST="$HOST" nixos-rebuild switch --flake ".#$HOST"
  system_status=$?
  if [ "$system_status" -ne 0 ]; then
    echo "NixOS switch failed (exit $system_status)." >&2
    if ! read -r -p "Continue with Home Manager anyway? [y/N] " continue_user; then
      exit "$system_status"
    fi
    case "$continue_user" in
    y | Y | yes | YES) ;;
    *) exit "$system_status" ;;
    esac
  fi
fi

if [ "$os_only" = false ]; then
  if ! command -v home-manager >/dev/null 2>&1; then
    echo "home-manager could not be found, run"
    echo "  nix-shell -p home-manager"
    exit 1
  fi

  echo "Rebuilding and activating home-manager"
  home-manager switch --flake ".#$USER@$HOST" #--impure
fi
