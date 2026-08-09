# NixOS Config

## Usage

- `jj` or `git add` any new files
- `nh`
```sh
nh os switch .
nh home switch .
```

### Setup

```sh
# 1. Install nix, enable flakes
export NIX_CONFIG="experimental-features = nix-command flakes"

# 2. Generate host config `/etc/nixos/{configuration.nix, hardware-configuration.nix}`
sudo nixos-generate-config
cp ~/etc/nixos/hardware-configuration ./hosts/<HOST>/hardware-configuration

# 3. Switch to config
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
sudo nixos-generate-config

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
# create shell with output of .#devShells.<system>.default or packages.<system>.default
nix develop
# use flake > .envrc => loads devShells.default
# run program
nix run nixpkgs#{package}

# collect garbage
sudo nix-collect-garbage --delete-older-than 30d
# optimize nix store
sudo nix-store --optimise
# /boot/kernels full of old generations: delete old generations, then collect garbage, nh os switch .
# sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
# sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5
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

---

```text
error booting grub /etf/Microsoft/... not found
```
- make sure fast boot disabled, windows isn't in hibernate

## Custom Components

### Packages
Add a derivation inside `pkgs` under `pkgs/{package name}/default.nix`, and call it with
`pkgs.callPackage` in `pkgs/default.nix`.

[Nixpkgs Reference Manual](https://nixos.org/manual/nixpkgs/stable/)

### Overlays
See `overlays/default.nix`. Use overlays to patch across the entire nixpkgs, e.g. set compile options
for a library, but requires compiling everything depending on it.

[Nix Overlays](https://wiki.nixos.org/wiki/Overlays)

#### Overrides
Prefer overrides when possible for making a change to a single package.

[Nix Overriding](https://nixos.org/manual/nixpkgs/stable/#chap-overrides)

### Modules
Custom modules with options/configurations go under `modules/nixos` or `modules/home-manager`.
Add to `modules/nixos/default.nix` or `modules/home-manager/default.nix`.

[NixOS Modules](https://wiki.nixos.org/wiki/NixOS_modules)

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
distrobox create -n ubuntu -i ubuntu:latest -H ~/ubuntu
distrobox create -n ubuntu -i ubuntu:latest -H ~/ubuntu --additional-packages "systemd libpam-systemd pipewire-audio-client-libraries"
distrobox enter ubuntu
```

### nvim subtree

Submodules don't work with flakes, using subtree for
[nvim-config](https://www.github.com/xiej2520/nvim-config).

```sh
git subtree pull --prefix home-manager/nvim-config https://github.com/xiej2520/nvim_config main --squash
git subtree push --prefix home-manager/nvim-config https://github.com/xiej2520/nvim_config main
git push https://github.com/xiej2520/nvim_config `git subtree split --prefix=home-manager/nvim_config main`:forcepush --force
```

## References

- [https://github.com/Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [https://github.com/ALEZ-DEV/dotfiles](https://github.com/ALEZ-DEV/dotfiles)
