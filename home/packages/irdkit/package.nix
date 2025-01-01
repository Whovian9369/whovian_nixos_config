{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule {
  pname = "irdkit";
  version = "0.9.3";
    # NuGet page: https://www.nuget.org/packages/LibIRD

  src = fetchFromGitHub {
    owner = "Deterous";
    repo = "LibIRD";
    rev = "048d70b473fa7bf84c6d490e9d05b653c6b2e54e";
    hash = "sha256-3o9+eo4DABG/TEhCxlMXvLDbzMNmr2H6UOBle9X0jHw=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps.json;
  projectFile = "IRDKit/IRDKit.csproj";
  selfContainedBuild = false;
  dotnetBuildFlags = [ "--framework net9.0" ];
  dotnetInstallFlags = [ "--framework net9.0" ];

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
