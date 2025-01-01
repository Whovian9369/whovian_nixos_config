{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule {
  pname = "libhac";
  version = "2024.08.29";

  src = fetchFromGitHub {
    owner = "Thealexbarney";
    repo = "LibHac";
    rev = "fefa38ff2204de978efdf9df1ff193d85d4d83e5";
    hash = "sha256-m+aHMNz0C77dJpukvkNTlTYBlUAkmJxGSB27UuNTGVc=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.json;
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
