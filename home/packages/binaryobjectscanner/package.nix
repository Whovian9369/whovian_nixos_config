{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule {
  pname = "binaryobjectscanner";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "BinaryObjectScanner";
    rev = "7738630952cdc2bb8f35dde24f49e3ae6a326d76";
    hash = "sha256-4STlTAToxv14eWcDyT/958zgoQvUnMgS1iw30knXs00=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps.nix;
  projectFile = ["ProtectionScan/ProtectionScan.csproj" "ExtractionTool/ExtractionTool.csproj"];
  selfContainedBuild = false;
  dotnetBuildFlags = [ "--framework net9.0" ];
  dotnetInstallFlags = [ "--framework net9.0" ];

  executables = [ "ExtractionTool" "ProtectionScan" ];

  preFixup = ''
    mv $out/bin/ExtractionTool $out/bin/bos-extractiontool
    mv $out/bin/ProtectionScan $out/bin/bos-protectionscan
  '';

  meta = {
    description = "C# protection, packer, and archive scanning library";
    homepage = "https://github.com/SabreTools/BinaryObjectScanner";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "bos-protectionscan";
    platforms = lib.platforms.all;
  };
}
