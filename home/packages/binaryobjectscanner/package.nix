{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule {
  pname = "binaryobjectscanner";
  version = "3.1.13";

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "BinaryObjectScanner";
    rev = "a4ee4529caeb9a1739518abcd1e5d0ddbd096d12";
    hash = "sha256-dSl1+8aoqRpPATQJuSGNyns9PGB7Olka5OJMg9MPz34=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.nix;
  projectFile = "Test/Test.csproj";
  selfContainedBuild = false;
  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];

  preFixup = ''
    mv $out/bin/Test $out/bin/binaryobjectscanner
  '';

  meta = {
    description = "C# protection, packer, and archive scanning library";
    homepage = "https://github.com/SabreTools/BinaryObjectScanner";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "binaryobjectscanner";
    platforms = lib.platforms.all;
  };
}
