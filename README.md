# NixOS Config

Submodules don't work with flakes, using subtree for
[nvim-config](https://www.github.com/xiej2520/nvim-config).

```sh
git subtree pull --prefix home-manager/nvim-config https://github.com/xiej2520/nvim-config main --squash
git subtree push --prefix home-manager/nvim-config https://github.com/xiej2520/nvim-config main
```

## To Build

1. Change config
2. Add new files to git repo
3. Run

   ```shell
   HOST=<HOSTNAME> ./build.sh
   ```

4. Check that programs are working

## Organization

## Notes

```shell
# check evaluation and test
nix flake check
# update flake lock
nix flake update

# generate /etc/nixos/{configuration.nix, hardware-configuration.nix}
nix-generate-config

# apply system configuration
sudo nixos-rebuild switch --flake .#{hostname}
# {switch, boot, test}
# e.g. sudo nixos-rebuild switch --flake .#WORKING_TABLET

# launch shell with home-manager
nix shell nixpkgs#home-manager

# apply home configuration
home-manager switch --flake .#username@hostname
# old configurations
home-manager generations
# switch to old generation
/nix/store/{hash}-home-manager-generation/activate

# nh commands
nh os switch . -H <HOSTNAME>
nh home switch .
nh search <pkg>
nh clean
```

### WSL

[NixOS-WSL](https://github.com/nix-community/NixOS-WSL?tab=readme-ov-file)

[Documentation](https://nix-community.github.io/NixOS-WSL/index.html)

1. Enable WSL

   ```Powershell
   wsl --install --no-distribution
   ```

2. Download [`nixos-wsl.tar.gz`](https://github.com/nix-community/NixOS-WSL/releases/latest).
3. Import

   ```Powershell
   wsl --import NixOS --version 2 $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz
   ```

4. Run

   ```Powershell
   wsl -d NixOS
   ```

## References

- [https://github.com/Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [https://github.com/ALEZ-DEV/dotfiles](https://github.com/ALEZ-DEV/dotfiles)
