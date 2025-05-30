{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "hactoolnet";
  version = "2024.08.29";

  src = fetchFromGitHub {
    owner = "Thealexbarney";
    repo = "LibHac";
    rev = "fefa38ff2204de978efdf9df1ff193d85d4d83e5";
    hash = "sha256-m+aHMNz0C77dJpukvkNTlTYBlUAkmJxGSB27UuNTGVc=";
  };

  # buildType = "Debug";
  buildType = "Release";
  /*
    [Parameter("Configuration to build - Default is 'Debug' (local) or 'Release' (server)")]
    public readonly string Configuration = IsLocalBuild ? "Debug" : "Release";
  */

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.json;
  projectFile = "src/hactoolnet/hactoolnet.csproj";
  # projectFile = "LibHac.sln";
  selfContainedBuild = false;
  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];

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
