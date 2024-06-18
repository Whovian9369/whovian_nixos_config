{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule {
  pname = "libird";
  version = "0.9.2";
    # NuGet page: https://www.nuget.org/packages/LibIRD

  src = fetchFromGitHub {
    owner = "Deterous";
    repo = "LibIRD";
    rev = "82d53db68f610d9cb972efa0dacb1c85a363880a";
    hash = "sha256-QPpS+zxH0fFoMGNA1AraqOseRaYJS+s67IGHKB6n2ig=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.nix;
  projectFile = "IRDKit/IRDKit.csproj";
  selfContainedBuild = false;
  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];

  executables = [ "irdkit" ];

  meta = {
    description = "Placeholder :)";
    homepage = "https://github.com/Deterous/LibIRD";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "irdkit";
    platforms = lib.platforms.all;
  };
}
