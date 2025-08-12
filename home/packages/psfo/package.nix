{ 
  lib,
  fetchFromGitHub,
  gcc13Stdenv,
}:

gcc13Stdenv.mkDerivation {
  pname = "sfo";
  version = "v1.02";

  src = fetchFromGitHub {
    name = "sfo";
    owner = "hippie68";
    repo = "sfo";
    rev = "b38cf18d8a5c60a7f05a604b8a67215b7fb67e0a";
    hash = "sha256-USW51qXBxWzbWBHo+Qa4Zm87YFfMDgrf2uW3R0vzPpA=";
  };

  # nativeBuildInputs = [  makeWrapper ];

  buildPhase = ''
    runHook preBuild
    gcc sfo.c -O3 -s -o sfo
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -v sfo $out/bin/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/hippie68/sfo";
    description = "Fast C program that reads a file to print or modify its SFO parameters";
    longDescription = "Fast C program that reads a file to print or modify its SFO parameters. Can be used for automation or to build param.sfo files from scratch.";
    license = lib.licenses.unfree;
      # No license file in repo.
    maintainers = [ lib.maintainers.whovian9369 ];
    mainProgram = "sfo";
    platforms = lib.platforms.linux;
  };
}
