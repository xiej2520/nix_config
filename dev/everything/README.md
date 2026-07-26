# dev environment

Persistent dev environment.
```sh
# use flake.nix
nix develop

# use shell.nix
nix-shell

# create GC root
nix build .#devShells.x86_64-linux.default --out-link ./result-devshell
nix build .#devShells.x86_64-linux.default

nix-build shell.nix -o .shell
```
