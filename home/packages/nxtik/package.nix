{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "nxtik";
  version = "v1.0";

  src = fetchFromGitHub {
    owner = "jam1garner";
    repo = "nxtik";
    rev = "b01fa605505b9bb38fac9ca6253f61b86f11abf8";
    hash = "sha256-S2vPMrwO6spasmkr3QXp0z6NGpwxxCpbxuVikMu3VOs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "binread-0.0.0" = "sha256-K1QGNJnVDI/bqsCWShhnREmTQtWh+1La49K9XUHSwhc=";
      "binread_derive-0.0.0" = "sha256-jK9x6edHiO/Q2xAoj00p6FahH6ToViKGm7jR+ArxzKw=";
    };
  };

  meta = with lib; {
    description = "A library and tool for parsing and outputting informatino about Nintendo Switch .tik files";
    homepage = "https://github.com/jam1garner/nxtik";
    license = licenses.unfree; # TODO: Developer forgot to add a license file.
    maintainers = with maintainers; [ ];
    mainProgram = "nxtik";
  };
}
