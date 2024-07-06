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
    rev = "63be4e4aedbc371111aef692debeb1024eb6bf41";
    hash = "sha256-2m1uJGHj/7qVUUIi5bbzOKxpGnFfGG1b41HCQLuUyeU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "binread-0.0.0" = "sha256-K1QGNJnVDI/bqsCWShhnREmTQtWh+1La49K9XUHSwhc=";
      "binread_derive-0.0.0" = "sha256-jK9x6edHiO/Q2xAoj00p6FahH6ToViKGm7jR+ArxzKw=";
    };
  };

  meta = {
    description = "Tool for parsing and outputting informatino about Nintendo Switch .tik files";
    homepage = "https://github.com/jam1garner/nxtik";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nxtik";
  };
}
