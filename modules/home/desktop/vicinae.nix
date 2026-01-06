{
  config,
  pkgs,
  inputs,
  inputs',
  osConfig,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    mkForce
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  config = mkIf sway.enable {
    services.vicinae = {
      enable = true;
      package = pkgs.vicinae; # Outdated but more stable version built by hydra
      systemd.enable = false; # Is started through sway

      settings = {
        pop_to_root_on_close = true;
        font.size = 10;
        favicon_service = "twenty";

        # Theme configuration with catppuccin currently bugged
        # https://github.com/catppuccin/nix/pull/800
        theme =
        let
        	ctp = config.catppuccin;
        in
        {
        	dark = {
        		name = "catppuccin-${ctp.flavor}";
            iconTheme = "Catppuccin ${lib.toSentenceCase ctp.flavor} ${lib.toSentenceCase ctp.accent}";
        	};
        };
      
        launcher_window = {
          csd = true;
          opacity = 0.95;
          rounding = 10;
        };
      };
    };

    wayland.windowManager.sway.config.menu = 
      "${getExe config.services.vicinae.package} toggle";
  };
}
 
