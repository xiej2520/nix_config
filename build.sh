#!/bin/sh

# Ensure HOST is set
if [ -z "$HOST" ]; then
  echo "HOST is not set. Please set HOST to the desired system name."
  exit 1
fi

sudo HOST=$HOST nixos-rebuild switch --flake .#$HOST --show-trace || exit # --impure
home-manager switch --flake .#$USER@$HOST || exit #--impure

