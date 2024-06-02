{
  agenix,
  config,
  ...
}:
{
  home.sessionVariables = {
    EDITOR = "nano";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    OPENAI_API_KEY = "\$(cat ${config.age.secrets."openai".path})";
    CURSEFORGE_API_KEY = "\$(cat ${config.age.secrets."cursed".path})";
    ITCHIO_API_KEY = "\$(cat ${config.age.secrets."itchy".path})";
    ELIXIRE_API_KEY = "\$(cat ${config.age.secrets."elixire".path})";
  };
}
