{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
let
    cfg = config.${namespace}.tools.kitty;
in
{
    options.${namespace}.tools.kitty = {
        enable = mkEnableOption "Kitty terminal configuration";
    };

    config = mkIf cfg.enable {
      programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;

        keybindings = {
          "strl+shift+l" = "clear";
        };

        font = {
          name = "JetBrains Mono";
          package = pkgs.jetbrains-mono;
          size = 12;
        };

        settings = {
          ## name: Rosé Pine
          ## author: mvllow
          ## license: MIT
          ## upstream: https://github.com/rose-pine/kitty/blob/main/dist/rose-pine.conf
          ## blurb: All natural pine, faux fur and a bit of soho vibes for the classy minimalist

          background_opacity = 0.9;

          foregrund = "#e0def4";
          background = "#191724";
          slection_foregrund = "#e0def4";
          selection_background = "#403d52";

          cursor = "#524f67";
          cursor_text_color = "#e0def4";

          url_color = "#c4a7e7";

          active_tab_foreground = "#e0def4";
          active_tab_background = "#26233a";
          inactive_tab_foreground = "#6e6a86";
          inactive_tab_background = "#191724";

          active_border_color = "#31748f";
          inactive_border_color = "#403d52";

          ## colors

          # black
          color0 = "#26233a";
          color8 = "#6e6a86";

          # red
          color1 = "#eb6f92";
          color9 = "#eb6f92";

          # green
          color2 = "#31748f";
          color10 = "#31748f";

          # yellow
          color3 = "#f6c177";
          color11 = "#f6c177";

          # blue
          color4 = "#9ccfd8";
          color12 = "#9ccfd8";

          # magenta
          color5 = "#c4a7e7";
          color13 = "#c4a7e7";

          # cyan
          color6 = "#ebbcba";
          color14 = "#ebbcba";

          # white
          color7 = "#e0def4";
          color15 = "#e0def4";
        };
      };
    };
}