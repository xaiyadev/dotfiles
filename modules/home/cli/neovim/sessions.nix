{
  programs.nixvim.plugins = {
    project-nvim = {
      enable = true;
      enableTelescope = true;
    };

    auto-save.enable = true;
    auto-session.enable = true;
    direnv.enable = true;
  };
}
