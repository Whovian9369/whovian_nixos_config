{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitLab,
}:

buildDotnetModule rec {
  pname = "hactoolnet";
  version = "2024.08.29";

  src = fetchFromGitLab {
    domain = "git.ryujinx.app";
    owner = "ryubing";
    repo = "LibHac";
    rev = "f5422bb13267a2897f70c209c7cf55af9d7595b6";
    hash = "sha256-KKCvMOpIXtG7uH0CpYRIKvTkz86kD9CwEmqWSeoiE80=";
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
