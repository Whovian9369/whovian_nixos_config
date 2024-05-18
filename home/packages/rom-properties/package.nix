{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  curl,
  libjpeg,
  libpng,
  libseccomp,
  lz4,
  lzo,
  nettle,
  pkg-config,
  tinyxml2,
  zlib,
  zstd,
  glib
}:

stdenv.mkDerivation {
  pname = "rom-properties";
  version = "git";

  src = fetchFromGitHub {
    owner = "GerbilSoft";
    repo = "rom-properties";
    rev = "1df55be31d5aab88db1ba722267255389a812802";
    hash = "sha256-e2K2XRPLLSXM+lWv5aFiU3PwotuUT0V8INAFc9QKmYY=";
  };

  nativeBuildInputs = [
    cmake
    nettle.dev
    pkg-config
    glib.dev
  ];

  buildInputs = [
    gettext
    curl.dev
    libjpeg.dev
    libpng.dev
    libseccomp.dev
    lz4.dev
    lzo
    tinyxml2
    zlib.dev
    zstd.dev
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DINSTALL_APPARMOR=OFF"
  ];

  postPatch = ''
    substituteInPlace "src/librpsecure/os-secure_linux.c" \
      --replace "SCMP_SYS(write)," "SCMP_SYS(write), SCMP_SYS(getdents64),"
  '';

  meta = {
    description = "ROM Properties Page shell extension";
    homepage = "https://github.com/GerbilSoft/rom-properties";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [  ];
    mainProgram = "rpcli";
    platforms = lib.platforms.all;
  };
}
