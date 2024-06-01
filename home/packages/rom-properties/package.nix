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

  /*
    About "postPatch"... patches.
      "src/librpsecure/os-secure_linux.c" change is needed to complete the
        build as it's not being detected automatically. (WSL Issue????)
      "src/rp-stub/CMakeLists.txt" change is needed to properly symlink
        `result/libexec/rp-thumbnail` to `result/bin/rp-stub` due to the odd
        double-path bug as described in
        https://github.com/NixOS/nixpkgs/issues/144170
          # CMake incorrect absolute include/lib paths tracking issue
        https://github.com/NixOS/nixpkgs/pull/172347 and
          #  cmake: add check-pc-files hook to check broken pc files
        https://github.com/NixOS/nixpkgs/pull/247474
          #  cmake: make check-pc-files hook also check .cmake files
  */
  postPatch = ''
    substituteInPlace "src/librpsecure/os-secure_linux.c" \
      --replace-fail "SCMP_SYS(write)," \
        "SCMP_SYS(write), SCMP_SYS(getdents64),"
    substituteInPlace "src/rp-stub/CMakeLists.txt" \
      --replace-fail "{CMAKE_INSTALL_PREFIX}/" ""
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


/*

  Notes:

  "$STORE_PATH" in these notes reference "nix/store/pnyxqz1vi124i18zdbl8ad1vypai73yg-rom-properties-git"
  "$CMAKE_INSTALL_BINDIR" matches variable in Cmake flags
  "$CMAKE_INSTALL_LIBDIR" matches variable in Cmake flags
  "$CMAKE_INSTALL_LIBEXECDIR" matches variable in Cmake flags
  =============================================================
  /$CMAKE_INSTALL_LIBDIR/debug/$STORE_PATH/$CMAKE_INSTALL_LIBEXECDIR/rp-download.debug
  /$CMAKE_INSTALL_LIBDIR/debug/$STORE_PATH/$CMAKE_INSTALL_LIBDIR/libromdata.debug
  /$CMAKE_INSTALL_LIBDIR/debug/$STORE_PATH/$CMAKE_INSTALL_BINDIR/rpcli.debug
  /$CMAKE_INSTALL_LIBDIR/debug/$STORE_PATH/$CMAKE_INSTALL_BINDIR/rp-thumbnail.debug
  /$CMAKE_INSTALL_LIBDIR/debug/$STORE_PATH/$CMAKE_INSTALL_BINDIR/rp-config.debug

  What I think I want the debug paths to end up as:
  $CMAKE_INSTALL_LIBDIR/debug/libexec/rp-download.debug
  $CMAKE_INSTALL_LIBDIR/debug/lib/libromdata.debug
  $CMAKE_INSTALL_LIBDIR/debug/bin/rpcli.debug
  $CMAKE_INSTALL_LIBDIR/debug/bin/rp-thumbnail.debug
  $CMAKE_INSTALL_LIBDIR/debug/bin/rp-config.debug

  ... Do I even need to build the debug executables anyway?

*/
