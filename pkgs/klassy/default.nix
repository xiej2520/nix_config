{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "klassy";
  version = "6.4.breeze6.4.0";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = pname;
    rev = version;
    # nix-prefetch-url --type sha256 --unpack https://github.com/paulmcauley/klassy/archive/refs/tags/6.4.breeze6.4.0.tar.gz
    sha256 = "0hrr8kg988qzpk8mccc8kk9lah9b89wx0h47s1981wvb9bci5dpr";
  };

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_QT5=OFF"
  ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kdecoration
    kdePackages.kcoreaddons
    kdePackages.kguiaddons
    kdePackages.kconfigwidgets
    kdePackages.kiconthemes
    kdePackages.kwayland
    kdePackages.kwindowsystem
    kdePackages.kirigami
    kdePackages.frameworkintegration
    kdePackages.kcmutils
    kdePackages.qtsvg
  ];

  meta = with lib; {
    description = "A highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
    homepage = "https://github.com/paulmcauley/klassy";
    license = with licenses; [
      gpl2Only
      gpl2Plus
      gpl3Only
      bsd3
      mit
    ];
  };
}
