{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromForgejo,
}:

buildDotnetModule rec {
  pname = "hactoolnet";
  version = "2026.04.01";

  src = fetchFromForgejo {
    domain = "git.ryujinx.app";
    owner = "projects";
    repo = "LibHac";
    rev = "873db0262d2d0c2388ac8dd954ec6a82c7d2b287";
    hash = "sha256-a8/fzBcnAIiDczRamLabloiyYI/0jmoLT0GwzAsp+PQ=";
  };

  # buildType = "Debug";
  buildType = "Release";
  /*
    [Parameter("Configuration to build - Default is 'Debug' (local) or 'Release' (server)")]
    public readonly string Configuration = IsLocalBuild ? "Debug" : "Release";
  */

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.json;
  projectFile = "src/hactoolnet/hactoolnet.csproj";
  # projectFile = "LibHac.sln";
  selfContainedBuild = false;
  # dotnetBuildFlags = [ "--framework net10.0" ];
  # dotnetInstallFlags = [ "--framework net8.0" ];

  executables = "hactoolnet";

  preConfigure = ''
    dotnet --version > DotnetCliVersion.txt
    patchShebangs --build build.sh
    for rid in $dotnetRuntimeIds; do dotnet restore --runtime "$rid" "build/_build.csproj"; done
    ./build.sh Codegen --configuration ${buildType}
  '';

  meta = {
    description = "A library that reimplements parts of the Nintendo Switch OS";
    homepage = "https://github.com/Thealexbarney/LibHac";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hactoolnet";
    platforms = lib.platforms.linux;
  };
}
