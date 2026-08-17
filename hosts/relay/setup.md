# NixOS Setup on Cloud VM

## Oracle Cloud

- [Install NixOS on a Free Oracle Cloud VM](https://mtlynch.io/notes/nix-oracle-cloud/)
  - worked
  1. ssh into VM
  2.
  ```bash
  sudo su
  # netboot ARM64
  wget https://boot.netboot.xyz/ipxe/netboot.xyz-arm64.efi && \
    sudo install \
      --owner=root \
      --group=root \
      --mode=664 \
      netboot.xyz-arm64.efi \
      /boot/efi/netboot.efi
  ```
  3. In Oracle Cloud UI, Instance -> OS Management -> Console Connection -> Launch Cloud Shell connection
    Wait for `Instance Console Connection reached state: ACTIVE`
  4. In SSH, `reboot`
  5. In Cloud Shell, hit `ESC` key as it reboots, and get into EFI boot manager (KVM Virtual Machine)
     Go to Boot Manager > EFI Internal Shell. Press any key to skip `startup.nsh`.
  6. In EFI Shell prompt, `fs0:netboot.efi`
  7. In netboot, go to Distrbutions > Linux Network Installs (arm64), NixOS, NixOS <nixos-version>
  8. Add SSH public key to `~/.ssh/authorized_keys`.
  9. Repartition cloud VM's disk
  ```bash
  sudo su
  cd "$(mktemp --directory)"
  # disk configuration file, 500MB boot partition
  curl \
    --show-error \
    --fail \
    https://mtlynch.io/notes/nix-oracle-cloud/disk-config.nix \
    > disk-config.nix

  # use disko to apply disk partitioning
  nix \
    --experimental-features 'nix-command flakes' \
    run \
    github:nix-community/disko/v1.11.0 \
    -- \
    --mode destroy,format,mount \
    disk-config.nix
  ```
  10. Install NixOS
  ```bash
  nixos-generate-config --no-filesystems --root /mnt
  mv disk-config.nix /mnt/etc/nixos/
  
  # use NixOS configuration files
  curl \
    --show-error \
    --fail \
    https://mtlynch.io/notes/nix-oracle-cloud/configuration.nix \
    > /mnt/etc/nixos/configuration.nix && \
    curl \
        --show-error \
        --fail \
        https://mtlynch.io/notes/nix-oracle-cloud/vars.nix \
        > /mnt/etc/nixos/vars.nix
  # edit vars.nix
  nixos-install --no-root-password
  shutdown --reboot now
  ```
  11. Download and apply this flake.

- [Deploying NixOS to Oracle Cloud Free Tier ARM Instances](https://erikparawell.com/oracle-cloud-nixos.html)
  - having issues with building the ARM image

## SSH Configuration
`nvim ~/.ssh/config`

```text
HOST <hostname>
  HostName <address>
  User <username>
  Identityfile <ssh private key path>
```

`ssh <hostname>` will prompt for ssh password.
