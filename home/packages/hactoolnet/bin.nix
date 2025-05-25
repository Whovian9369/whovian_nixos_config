{
  lib,
  autoPatchelfHook,
  fetchzip,
  gcc,
  makeWrapper,
  openssl,
  stdenv,
  zlib
}:

stdenv.mkDerivation rec {
  name = "hactoolnet-bin";
  version = "0.19.0";

  src = fetchzip {
    url = "https://github.com/Thealexbarney/LibHac/releases/download/v${version}/hactoolnet-${version}-linux.zip";
    hash = "sha256-njlIFsAjyKErYatbP+3fmjP5dv3DhJ7G1+KvC2ZPdso=";
  };

  buildInputs = [
    autoPatchelfHook
    makeWrapper
    gcc.cc
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin
    chmod +x hactoolnet
    cp hactoolnet $out/bin/
    wrapProgram $out/bin/hactoolnet \
      --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1 \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ openssl ]}
  '';

  meta = {
    description = "An example program that uses LibHac. It is used in a similar manner to hactool.";
    homepage = "https://github.com/Thealexbarney/LibHac";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hactoolnet";
    platforms = lib.platforms.all;
  };
}
