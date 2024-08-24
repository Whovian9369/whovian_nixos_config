{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule {
  pname = "libhac";
  version = "2024.06.17";

  src = fetchFromGitHub {
    owner = "Thealexbarney";
    repo = "LibHac";
    rev = "559b8c89f9ba2913f5e8e6630ecb2c21c13dcd31";
    hash = "sha256-m8NNsfnQNFLuPHunKMw2k0avbkH5/p/+Ucx/nwU7JPQ=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.nix;
  projectFile = "src/hactoolnet/hactoolnet.csproj";
  selfContainedBuild = false;
  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];

  meta = {
    description = "A library that reimplements parts of the Nintendo Switch OS";
    homepage = "https://github.com/Thealexbarney/LibHac";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hactoolnet";
    platforms = lib.platforms.linux;
  };
}
