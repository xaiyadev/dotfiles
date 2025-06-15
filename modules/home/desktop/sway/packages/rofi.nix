{ pkgs, osConfig, ... }:
let

  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in
{

  programs.rofi = {
    enable = builtins.elem "sway" windowManagers;
    package = pkgs.rofi-wayland;

    # Only working when calling rofi from the terminal right now
    # Refer to https://discourse.nixos.org/t/rofi-on-wayland-and-plugins/17354/8
    plugins = [ pkgs.rofi-emoji-wayland ];
    modes = [ "combi" "drun" /* "emoji" */ ];

    terminal = "${pkgs.kitty}/bin/kitty";
  };

  home.packages = [ # TODO: configuration
    pkgs.rofi-rbw-wayland
  ];

  wayland.windowManager.sway.config.menu =
    ''${pkgs.rofi-wayland}/bin/rofi \
      -modi power:"${pkgs.rofi-power-menu}/bin/rofi-power-menu --symbols-font 'Symbols Nerd Font Mono'" \
      -combi-modi "drun,power,emoji" \
      -show-icons \
      -show combi'';
}
