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
  glib,

  # Use "Ninja" for the build.
  useNinja ? false,
  ninja,

  # Enable GNOME "Tracker".
  useTracker ? false,
  tracker
}:

stdenv.mkDerivation {
  pname = "rom-properties";
  version = "git";

  src = fetchFromGitHub {
    owner = "GerbilSoft";
    repo = "rom-properties";
    rev = "10c20ccc3b5550e7950e036a56b0a34714edb263";
    hash = "sha256-uoyD2xuPkdoKidyG1Dlckk5ImKnGw/rk8G27IS1cTes=";
  };

  nativeBuildInputs = [
    cmake
    nettle.dev
    pkg-config
    glib.dev
    tinyxml2
  ]
  ++ lib.optionals useNinja [ ninja ];

  buildInputs = [
    gettext
    curl.dev
    libjpeg.dev
    libpng.dev
    libseccomp.dev
    lz4.dev
    lzo
    zlib.dev
    zstd.dev
    tinyxml2
  ]
  ++ lib.optionals useTracker [ tracker ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_APPARMOR" false)
    (lib.cmakeBool "ENABLE_DECRYPTION" true)
    (lib.cmakeBool "ENABLE_EXTRA_SECURITY" true)
    (lib.cmakeBool "ENABLE_JPEG" true)
    (lib.cmakeBool "ENABLE_XML" true)
    (lib.cmakeBool "ENABLE_UNICE68" true)
    (lib.cmakeBool "ENABLE_LIBMSPACK" true)
    (lib.cmakeBool "ENABLE_PVRTC" true)
    (lib.cmakeBool "ENABLE_ZSTD" true)
    (lib.cmakeBool "ENABLE_LZ4" true)
    (lib.cmakeBool "ENABLE_LZO" true)
    (lib.cmakeBool "ENABLE_NLS" true)
    (lib.cmakeBool "ENABLE_OPENMP" true)
  ] ++ lib.optionals useTracker [ (lib.cmakeFeature "TRACKER_INSTALL_API_VERSION" "3") ];

  patches = [
    ./patches/fix_debug_paths.diff
    ./patches/fix_getdents64_build.diff
    ./patches/fix_rp-stub_symlink.diff
  ];

  /*
    About "patches":
      "fix_debug_paths.diff" is needed to properly have some correct debug
        paths, due to "cmake"'s weird path issues.
      (See below references for "fix_rp-stub_symlink.diff".)

      "fix_getdents64_build.diff" is needed to properly complete and then run
        the build as it's not being detected automatically.
      (Maybe it's an issue with WSL?)

      "fix_rp-stub_symlink.diff" is needed to properly symlink
        `result/libexec/rp-thumbnail` to `result/bin/rp-stub` due to the odd
        double-path bug as described in
        https://github.com/NixOS/nixpkgs/issues/144170
          # CMake incorrect absolute include/lib paths tracking issue
        https://github.com/NixOS/nixpkgs/pull/172347 and
          #  cmake: add check-pc-files hook to check broken pc files
        https://github.com/NixOS/nixpkgs/pull/247474
          #  cmake: make check-pc-files hook also check .cmake files
  */

  meta = {
    description = "ROM Properties Page shell extension";
    homepage = "https://github.com/GerbilSoft/rom-properties";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [  ];
    mainProgram = "rpcli";
    platforms = lib.platforms.all;
  };
}

###################################################################

/* NOTES

  Package 'libpcre2-8', required by 'glib-2.0', not found
  Package libpcre2-8 was not found in the pkg-config search path.
  Perhaps you should add the directory containing `libpcre2-8.pc'

*/
