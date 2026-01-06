{
  osConfig,
  lib,
  pkgs,
  config,
  inputs',
  ...
}:
let
  inherit (lib)
    mkIf
    mkOptionDefault
    concatStringsSep
    getExe
    ;

  modifier = "Mod4";
  sway = osConfig.sylveon.system.graphical.sway;
  cfg = config.wayland.windowManager.sway.config;
in
{
  imports = [
    ./packages # Load extra packages
    ./config # Load sway configurations
  ];

  config = mkIf sway.enable {
    wayland.windowManager.sway = {
      enable = true;

      # Package is set to null because it is already created in the original config
      package = null;

      systemd = {
        enable = true;
        xdgAutostart = true;
      };

      config = {
        inherit modifier;
        terminal = "${getExe config.programs.kitty.package}";

        colors = 
          let
            submodule = {
              childBorder = "$base";
              indicator = submodule.childBorder;

              # Configuration needed only if using the title bar
              text = "$text";
              border = "#ffffff";
              background = "#ffffff";
            };
          in
          {
            focused = submodule // rec {
            	childBorder = "\$${config.catppuccin.accent}";
            	indicator = childBorder;
            };

            urgent = submodule // rec {
            	childBorder = "$red";
            	indicator = childBorder;
            };

            placeholder = submodule;
            focusedInactive = submodule;
            unfocused = submodule;
          };

        keybindings = mkOptionDefault {
          "${modifier}+Escape" = "exec ${getExe config.programs.swaylock.package}";

          "${modifier}+shift+s" =
            ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy''; # Take a screenshot

          "${modifier}+e" = ''exec ${pkgs.nemo-with-extensions}/bin/nemo'';
        };
      };

      # SwayFx specific configuration
      extraConfig = concatStringsSep "\n" [
        "shadows enable"
        "corner_radius 13"
      ];
    };
  };
}
