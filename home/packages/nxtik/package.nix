{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "nxtik";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "jam1garner";
    repo = "nxtik";
    rev = "9f9fe67e70a4cf1353e5e4d14075ec23a585be0a";
    hash = "sha256-kpoPjYd57aE4hWXsbH6Twmdmyjv7QVczgXxae5I/VVc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "binread-2.2.0" = "sha256-nSsWrmKa+bZ7S4L8n1WSjEf4UkpHilx3u0hj+PQEYcI=";
    };
  };

  # buildType = "debug";
  # separateDebugInfo = true;

  meta = {
    description = "Tool for parsing and outputting informatino about Nintendo Switch .tik files";
    homepage = "https://github.com/jam1garner/nxtik";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nxtik";
  };
}
