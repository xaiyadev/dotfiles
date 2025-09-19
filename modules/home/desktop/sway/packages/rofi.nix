{
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    concatStringsSep
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  programs.rofi = mkIf sway.enable {
    enable = true;
    package = pkgs.rofi;

    # Only working when calling rofi from the terminal right now
    # Refer to https://discourse.nixos.org/t/rofi-on-wayland-and-plugins/17354/8
    modes = [
      "combi"
      "drun" # "emoji"
    ];

    terminal = "${pkgs.kitty}/bin/kitty";
  };

  wayland.windowManager.sway.config.menu = concatStringsSep ''\'' [
    ''${pkgs.rofi}/bin/rofi ''
    ''-modi power:"${pkgs.rofi-power-menu}/bin/rofi-power-menu" --symbols-font "Symbols Nerd Font Mono" ''
    ''-combi-modi "drun,power" ''
    ''-show-icons ''
    ''-show combi ''
  ];
}
