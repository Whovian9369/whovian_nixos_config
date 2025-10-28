{
  lib,
  cmake,
  fetchFromGitHub,
  mbedtls,
  perl,
  python3,
  stdenv,

  ### Ninja
  withNinja ? false,
  ninja
}:

stdenv.mkDerivation {
  pname = "ps3dec";
  version = "unstable-2018-12-16";

  src = fetchFromGitHub {
    owner = "al3xtjames";
    repo = "PS3Dec";
    rev = "7d1d27f028aa86cd961a89795d0d19a9b3771446";
    hash = "sha256-kvkkB7NclFfbqf3vqwFjKOFwHUz1X+KRCwGopN7YCis=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  nativeBuildInputs = [
    cmake
    mbedtls
    perl
    python3
  ] ++ lib.optionals withNinja ninja;

  installPhase = ''
    mkdir -p $out/bin
    mv Release/PS3Dec $out/bin/ps3dec
  '';

  meta = {
    description = "PS3Dec r5 source mirror";
    homepage = "https://github.com/al3xtjames/PS3Dec";
    license = lib.licenses.unfree;
      # Technically it was posted to the 3k3y forums without a license file,
      # So technically it's probably "All Rights Reserved"...
      # I think that's how this works?
    maintainers = with lib.maintainers; [ ];
  };
}
