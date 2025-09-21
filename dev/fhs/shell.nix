#!/usr/bin/env nix-shell

{
  pkgs ? import <nixpkgs> { },
}:

(
  let
    base = pkgs.appimageTools.defaultFhsEnvArgs;
  in
  pkgs.buildFHSEnv (
    base
    // {
      name = "FHS";
      targetPkgs =
        pkgs:
        (with pkgs; [
        ]);
      runScript = "bash";
      extraOutputsToInstall = [ "dev" ];
    }
  )
).env
