{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "irdkit";
  version = "1.0.1";
    # NuGet page: https://www.nuget.org/packages/LibIRD

  src = fetchFromGitHub {
    owner = "Deterous";
    repo = "LibIRD";
    tag = "v${version}";
    hash = "sha256-7ikZKrqLXiip78oLI2khS+/QQpmzZ2p84eGRDluVMR8=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps.json;
  projectFile = "IRDKit/IRDKit.csproj";
  selfContainedBuild = false;
  dotnetBuildFlags = [ "--framework net10.0" ];
  dotnetInstallFlags = [ "--framework net10.0" ];

  executables = [ "irdkit" ];

  meta = {
    description = "Tool that allows direct use of LibIRD functionality from a command line interface";
    homepage = "https://github.com/Deterous/LibIRD";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "irdkit";
    platforms = lib.platforms.all;
  };
}
