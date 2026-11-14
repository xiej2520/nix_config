pkgs:
with pkgs; [
  stdenv.cc.cc.lib
  glibc
  libxcrypt
  libGL
  libdrm
  libgbm
  udev
  libudev0-shim
  libva
  vulkan-loader
  networkmanager
  libcap

  openssl
  wayland
  libxkbcommon
  fontconfig
  freetype
  expat
  zlib
  alsa-lib
  libpulseaudio

  libX11
  libxcursor
  libxi
  libxrandr
  libxrender
  libxext
  libxcb
]
