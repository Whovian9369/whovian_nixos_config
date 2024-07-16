{
  lib,
  stdenv,
  cmake,
  curl,
  fetchFromGitHub,
  gettext,
  glib,
  libjpeg,
  libpng,
  libseccomp,
  lz4,
  lzo,
  nettle,
  pkg-config,
  tinyxml-2,
  zlib,
  zstd,

  # Not really required afaik, but I like quieting the warnings :)
  pcre2,
  minizip-ng,
  libselinux,
  libsepol,
  util-linux,
  inih,

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
    rev = "eba71880c1f36bb059be662c70a4eefba2b88226";
    hash = "sha256-K8Tn2z8GwJkjLVPOjIBvj1M63+ivMwqfydSFVAMVtI0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    # So many "dev" package outputs, lol
    nettle.dev
    glib.dev
    libselinux.dev
    libsepol.dev
    pcre2.dev
    util-linux.dev
    curl.dev
    libjpeg.dev
    libpng.dev
    libseccomp.dev
    lz4.dev
    zlib.dev
    zstd.dev
  ]
  ++ lib.optionals useNinja [ ninja ];

  buildInputs = [
    gettext
    lzo
    tinyxml-2
    minizip-ng
    inih
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

  *** ROM Properties Page Shell Extension v2.3.0+ ***
  Build Summary:
  - Target CPU architecture: amd64
  - Building these UI frontends:
  - Building command-line frontend: Yes
  - GNOME Tracker API version: (none)
  - libromdata is built as: shared library (.so)
  - Security mechanism: seccomp()
  - Decryption functionality: Enabled
  - XML parsing: Enabled (system)
  - PVRTC decoder: Enabled
  - ZSTD decompression: Enabled (system)
  - LZ4 decompression: Enabled (system)
  - LZO decompression: Enabled (system)
  Building these third-party libraries from extlib:
  - minizip-ng
  - inih

*/
