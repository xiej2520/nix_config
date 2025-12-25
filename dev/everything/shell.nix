# nix-shell
let
  nixpkgs = import <nixpkgs> { };
in
with nixpkgs;
stdenv.mkDerivation {
  name = "dev environment";
  buildInputs = [
    autoconf
    automake

    clang
    clang-tools
    codespell
    cppcheck
    doxygen
    gcc
    gdb
    lcov
    lld
    lldb
  ]
  ++ [
    rustc
    cargo
    clippy
    cargo-deny
    cargo-edit
    cargo-watch
    rust-analyzer
    llvmPackages.bintools # lld
    openssl
  ]
  ++ [
    abseil-cpp
    cmake
    conan
    fmt
    gtest
    vcpkg
    vcpkg-tool
  ]
  ++ [
    openjdk
    gradle
    maven
  ]
  ++ [
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        numpy
        pandas
        requests
        venvShellHook
      ]
    ))
  ]
  ++ [
    nodejs
    node2nix
  ]
  ++ [
    typst
  ]
  ++ [
    nixpkgs-fmt
  ];
  OPENSSL_DEV = openssl.dev;
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  RUSTFLAGS = "-Clink-arg=-fuse-ld=lld";
}
