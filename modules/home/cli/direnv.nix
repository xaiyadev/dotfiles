{
  config,
  ...
}:
{

  config = {
    programs.direnv = {
      enable = true;

      enableZshIntegration = config.programs.zsh.enable;
      nix-direnv.enable = true;
    };

    # Enable starship configuration for direnv
    programs.starship.settings.direnv.disabled = !config.programs.direnv.enable;
  };
}
