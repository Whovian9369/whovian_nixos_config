{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub
}:

buildDotnetModule {
  pname = "binaryobjectscanner";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "BinaryObjectScanner";
    rev = "1ff1281c8f7075cf0ad0611eab679259618ac407";
    hash = "sha256-XvtwEPkL8whuWv7d7/qDVs2nbcm+v/Wrtu5bIp7Ujuk=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps.json;
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
