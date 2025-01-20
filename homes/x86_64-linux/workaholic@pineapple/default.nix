{
  lib,
  pkgs,
  inputs,

  namespace,
  home,
  target,
  format,
  virtual,
  host,

  config,
  ...

}:
with lib;
with lib.sylveon;
{


  # Add Yubikey u2f_keys
  home.file.".config/Yubico/u2f_keys".text = "workaholic:/QTAm5AwwzzYdRUl6RwUlMZVnaTFwghjh5fRclYmRi1cMdPEd7YQ8vY5TCu6z0c/L6BXlChd2BD64Wml+jb6gg==,w0iWnO7O9Hzo+kn+3PmuGBbAlo56d+oLBxRW7Bgz3F9JUOXNiJyoSyJ0/isisnSQBJUA6nX9HDpEV2E4GlKWnQ==,es256,+presence";

  sylveon = { # if using namespace here, you will get an error
    cli = {
      kitty = enabled;
      neovim = enabled;
    };

    apps = {
      music.spotify = enabled; 
      #music.tidal = enabled;

      browser.chromium = enabled;
      #browser.zen = enabled;

      social = {
        teams = enabled; # This instance is used for work
      };

      development = {
        jetbrains.phpstorm = enabled;
      };

      security = {
        enpass = enabled;
        yubikey = enabled;
      };

      files.obsidian = enabled;
    };

    tools = {
      direnv = enabled;
      git = {
        enable = true;
        user.name = "Danil Schumin";
        user.email = "d.schumin@blmedia.de"; #
	      ssh-key = "~/.ssh/id_rsa";
      };
    };

  };

  /* User specific configurations */
  programs.chromium.extensions = [ { id = "kmcfomidfpdkfieipokbalgegidffkal"; } ]; # Add the enpass browser extension

  home.stateVersion = "24.05";
}
