{
  agenix,
  config,
  ...
}:
{

  home.sessionVariables = {
    CURSEFORGE_API_KEY = "\\\$2a\\\$10\\\$bL4bIL5pUWqfcO7KQtnMReakwtfHbNKh6v1uTpKlzhwoueEJQnPnm";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    EDITOR = "nano";
    MANPAGER= "bat -p";
    # OPENAI_API_KEY = "\$(cat ${config.age.secrets."openai".path})";
    # ITCHIO_API_KEY = "\$(cat ${config.age.secrets."itchy".path})";
    # ELIXIRE_API_KEY = "\$(cat ${config.age.secrets."elixire".path})";
  };

  home.sessionPath = [
    "$HOME/bin"
  ];
}
