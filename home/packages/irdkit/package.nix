{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule {
  pname = "irdkit";
  version = "1.0.0";
    # NuGet page: https://www.nuget.org/packages/LibIRD

  src = fetchFromGitHub {
    owner = "Deterous";
    repo = "LibIRD";
    rev = "44928620513fbcdadaa26e601f1b902415da044f";
    hash = "sha256-srEztsG8lUay9u+AAb89DJ8KdS+Iwcz5PJ/rTDkENaQ=";
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
    description = "Tool that allows direct use of LibIRD functionality from a command line interface";
    homepage = "https://github.com/Deterous/LibIRD";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "irdkit";
    platforms = lib.platforms.all;
  };
}
