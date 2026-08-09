{
  config,
  pkgs,
  ...
}:
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      # llama.cpp v0.2.0 with ROCm + OpenBLAS + native CPU optimizations
      llama-cpp =
        (pkgs.llama-cpp.override {
          cudaSupport = false;
          rocmSupport = true;
          metalSupport = false;
          # Enable OpenBLAS for optimized CPU layer performance (OpenBLAS)
          # This is crucial for models using split-mode or CPU offloading
          blasSupport = true;
        }).overrideAttrs
          (oldAttrs: rec {
            #version = "0.2.0";
            src = pkgs.fetchFromGitHub {
              owner = "ggml-org";
              repo = "llama.cpp";
              tag = "v0.2.0";
              hash = "sha256-46b+5YWwF5k1vBBzsjSCrn6k8dkPuBYy2bqWhgFqCbQ=";
            };
            npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
            # Enable native CPU optimizations for massively better CPU performance
            # This enables AVX, AVX2, AVX-512, FMA, etc. for your specific CPU
            # NOTE: This is intentionally opposite of nixpkgs (which uses -DGGML_NATIVE=off
            # for reproducible builds). We sacrifice portability for faster CPU layers.
            cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
              "-DGGML_NATIVE=ON"
              "-DGPU_TARGETS=gfx1101" # RX 7800 XT
            ];

            # Disable Nix's NIX_ENFORCE_NO_NATIVE which strips -march=native flags
            # See: https://github.com/NixOS/nixpkgs/issues/357736
            # See: https://github.com/NixOS/nixpkgs/pull/377484 (intentionally contradicts this)
            preConfigure = ''
              export NIX_ENFORCE_NO_NATIVE=0
              ${oldAttrs.preConfigure or ""}
            '';
          });

      # llama-swap from GitHub releases
      llama-swap = pkgs.runCommand "llama-swap" { } ''
        mkdir -p $out/bin
        tar -xzf ${
          pkgs.fetchurl {
            url = "https://github.com/mostlygeek/llama-swap/releases/download/v251/llama-swap_251_linux_amd64.tar.gz";
            hash = "sha256-hb1/Ix9Xd/9ri3h6eU+CVni40ELNRIQERRaljs3HYis=";
          }
        } -C $out/bin
        chmod +x $out/bin/llama-swap
      '';
    };
  };
}
