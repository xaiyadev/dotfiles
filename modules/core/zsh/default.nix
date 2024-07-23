{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.zsh;
in
{
    options.services.zsh = {
        enable = mkEnableOption "custom zsh service";
    };

    config = mkIf cfg.enable {
	users.defaultUserShell = pkgs.zsh;
	environment.shells = [ pkgs.zsh ];        

	programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestions.enable = true;
          syntaxHighlighting.enable = true;

            ohMyZsh = {
              enable = true;
              plugins = [ "git" ];
              theme = "agnoster";
            };

        };
    };
}
