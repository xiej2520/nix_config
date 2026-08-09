# GC and Optimization Log

```bash
# collect garbage
sudo nix-collect-garbage --delete-older-than 30d
# optimize nix store
sudo nix-store --optimise
# /boot/kernels full of old generations: delete old generations, then collect garbage, nh os switch .
# sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
# sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5
```

## 2026-05-30 gc
note: hard linking is currently saving 0.0 KiB
3948 store paths deleted, 23.0 GiB freed
## 2026-05-31 optimize
69.6 GiB freed by hard-linking 4319626 files

## 2026-06-21 gc
deleting unused links...
note: hard linking is currently saving 69.0 GiB
2368 store paths deleted, 9.3 GiB freed
## 2026-06-21 optimize
6.2 GiB freed by hard-linking 609918 files

## 2026-08-09 gc older than 30
deleting unused links...
note: hard linking is currently saving 66.1 GiB
21858 store paths deleted, 50.1 GiB freed
## 2026-08-09 optimize
54.3 GiB freed by hard-linking 2639530 files

## 2026-08-17 relay gc and optimize
deleting unused links...
note: hard linking is currently saving -4.0 KiB
1201 store paths deleted, 923.6 MiB freed

830.8 MiB freed by hard-linking 145767 files

total 7.02 GiB -> 5.33 GiB

