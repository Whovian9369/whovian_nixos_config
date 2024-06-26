{
  xdg.configFile = {
    rustfmt = {
      enable = true;
      target = "rustfmt/rustfmt.toml";    
      text = ''
          tab_spaces = 2
          hard_tabs = false
          # indent_style = "Block"
            # TODO: "Unstable" as of rustfmt 1.7.0
          reorder_imports = true
      '';
    };
  };
}
