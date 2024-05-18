{ lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule {
  pname = "sabretools";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "SabreTools";
    rev = "806d0221d0f4275239feb1f47f08c7c1d2c0f911";
    hash = "sha256-qEoHKQYe1IuXYmxGRgq2idRIDarqZlhPgtikw52kJQU=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.nix;
  projectFile = "SabreTools.sln";
  # projectFile = "SabreTools/SabreTools.csproj";
  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];

  meta = {
    description = "DAT management tool with advanced editing and sorting features";
    homepage = "https://github.com/SabreTools/SabreTools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "SabreTools";
    platforms = lib.platforms.all;
  };
}
