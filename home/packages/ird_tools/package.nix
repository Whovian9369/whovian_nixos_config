{
  lib,
  fetchFromGitHub,
  gcc13Stdenv,
  makeWrapper,
  zlib,
  glibc,
}:

gcc13Stdenv.mkDerivation {
  pname = "ird_tools";
  version = "v0.7";

  src = fetchFromGitHub {
    name = "ird_tools";
    owner = "Zarh";
    repo = "ird_tools";
    rev = "9489afc0979715a86fbfb6b5a9a93330863505eb";
    hash = "sha256-1m243bPabo2riOInblDggqTniXg1f16UqeLXJfEBrf4=";
  };

  nativeBuildInputs = [  makeWrapper glibc.static zlib.static zlib.dev ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ird_tools $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Zarh/ird_tools";
    description = "DESCRIPTION PLACEHOLDER";
    longDescription = "DESCRIPTION PLACEHOLDER";
    # license = lib.licenses.gpl3;
    license = lib.licenses.unfree;
    /*
      Dev feels that it should be GPLv3, but doesn't have a `LICENSE` file in
      the repository "proving" the licensing. Running with it for now.
      Info on this: https://github.com/Zarh/ird_tools/issues/3
      I'm keeping `lib.licenses.gpl3` license comment just to make sure I
      remember to change it back... If the dev adds the file.
    */
    maintainers = with lib.maintainers; [  ];
    mainProgram = "ird_tools";
    platforms = lib.platforms.linux;
  };
}
