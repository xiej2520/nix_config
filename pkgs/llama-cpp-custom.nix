{
  llama-cpp,
  fetchFromGitHub,
}:
(llama-cpp.override {
  cudaSupport = false;
  rocmSupport = true;
  metalSupport = false;
  # Enable OpenBLAS for optimized CPU layer performance (OpenBLAS)
  # This is crucial for models using split-mode or CPU offloading
  blasSupport = true;

  # RX 7800 XT
  rocmGpuTargets = [ "gfx1101" ];
}).overrideAttrs(oldAttrs: {
  #version = "0.2.0";
  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "v0.4.1";
    hash = "sha256-vVq7+eUN6NXZuqm7Jwlr4iFDV1PjNzQ6nK9AR2zvZYM=";
  };
  npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
  # Enable native CPU optimizations for massively better CPU performance
  # This enables AVX, AVX2, AVX-512, FMA, etc. for your specific CPU
  # NOTE: This is intentionally opposite of nixpkgs (which uses -DGGML_NATIVE=off
  # for reproducible builds). We sacrifice portability for faster CPU layers.
  cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
    "-DGGML_NATIVE=ON"
  ];

  # Disable Nix's NIX_ENFORCE_NO_NATIVE which strips -march=native flags
  # See: https://github.com/NixOS/nixpkgs/issues/357736
  # See: https://github.com/NixOS/nixpkgs/pull/377484 (intentionally contradicts this)
  preConfigure = ''
    export NIX_ENFORCE_NO_NATIVE=0
    ${oldAttrs.preConfigure or ""}
  '';
})
