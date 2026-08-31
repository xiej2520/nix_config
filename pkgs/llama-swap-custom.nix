{
  fetchurl,
  gnutar,
  gzip,
  stdenvNoCC
}:
stdenvNoCC.mkDerivation {
  pname = "llama-swap";
  version = "251";

  src = fetchurl {
    url = "https://github.com/mostlygeek/llama-swap/releases/download/v251/llama-swap_251_linux_amd64.tar.gz";
    hash = "sha256-hb1/Ix9Xd/9ri3h6eU+CVni40ELNRIQERRaljs3HYis=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ gnutar gzip ];

  installPhase = ''
    runHook preInstall
    install -d "$out/bin"
    tar -xzf "$src" -C "$out/bin"
    chmod 0755 "$out/bin/llama-swap"
    runHook postInstall
  '';

  meta = {
    platforms = [ "x86_64-linux" ];
    mainProgram = "llama-swap";
  };
}
