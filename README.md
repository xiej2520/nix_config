# NixOS Config

Submodules don't work with flakes, using subtree for
[nvim-config](https://www.github.com/xiej2520/nvim-config).

```sh
git subtree pull --prefix home-manager/nvim-config https://github.com/xiej2520/nvim-config main --squash
git subtree push --prefix home-manager/nvim-config https://github.com/xiej2520/nvim-config main
```

## Usage

1. Change config
2. `git add` any new files
3. `nh`

   ```shell
   nh os switch .
   nh home switch .
   ```

4. Check that programs are working

### Setup

1. Install nix, enable flakes
2. Run

   ```shell
   nix-shell -p home-manager
   HOST=<HOSTNAME> USER=<USERNAME> ./switch.sh
   ```

## Organization

- `.#xiej@WORKING-DESKTOP`
- `.#xiej@WORKING-LAPTOP`

## Notes

### nix commands

```shell
nix flake check
nix flake update

# generate /etc/nixos/{configuration.nix, hardware-configuration.nix}
nix-generate-config

# apply system configuration
# {switch, boot, test}
sudo nixos-rebuild switch --flake .#{hostname}
# apply home configuration
home-manager switch --flake .#username@hostname
# old configurations
home-manager generations
# switch to old generation
/nix/store/{hash}-home-manager-generation/activate

# launch shell with output of flake
nix-shell -p {package}
nix shell nixpkgs#{package}
# create shell with buildInputs and env variables
nix develop nixpkgs#{package}
# run program
nix run nixpkgs#{package}
```

### nh commands

```shell
nh os switch . -H <HOSTNAME>
nh home switch .

nh os switch --update .
nh home switch --update .

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

### distrobox

```shell
distrobox create -n ubuntu -i ubuntu:latest -H ~/Documents/distrobox-ubuntu
distrobox create -n ubuntu -i ubuntu:latest -H ~/Documents/distrobox-ubuntu --additional-packages "systemd libpam-systemd pipewire-audio-client-libraries"
```

## References

- [https://github.com/Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [https://github.com/ALEZ-DEV/dotfiles](https://github.com/ALEZ-DEV/dotfiles)
