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
    cfg = config.${namespace}.desktop.sway;
in
{
    options.${namespace}.desktop.sway = {
        enable = mkEnableOption "Activate all the neceasery tools for sway to work";
    };


    config = mkIf cfg.enable {

      programs.sway = {
        enable = true;
        package = pkgs.swayfx; /* https://github.com/nix-community/nixpkgs-wayland/issues/468 */

        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
          wayland

          wl-clipboard
          wlroots

          mako # notifaction system

          /* Screenshot Utilities */
          grim
          slurp
        ];

        extraSessionCommands = ''
          export WLR_RENDERER=vulkan
          export SDL_VIDEODRIVER=wayland
          export QT_QPA_PLATFORM=wayland
          export _JAVA_AWT_WM_NONREPARENTING=1
          export MOZ_ENABLE_WAYLAND=1
        '';

      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common = {
          default = [
            "gtk"
            "wlr"
          ];
        };
      };

      /* Small important things that will be activated */
      services.gnome.gnome-keyring.enable = true;
      services.dbus.enable = true;

      /* Activate Display Manager and add a custom sway session */
      services.xserver.enable = true;
      services.displayManager = {
        sddm = {
          enable =  true;
          wayland.enable = true;
        };

        sessionPackages = let
         swayFXEntry = pkgs.writeTextFile {
                   name = "sway.desktop";
                   destination = "/share/wayland-sessions/sway.desktop";
                   text = ''
                    [Desktop Entry]
                    Name=SwayFX with unsupported GPU
                    Comment=SwayFX Startup with Unsupported GPU
                    Exec=env ${pkgs.swayfx}/bin/sway --unsupported-gpu
                    Type=Application
                   '';
                   checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
                   derivationArgs = { passthru.providedSessions = [ "sway" ]; };
                 };
         in [ swayFXEntry ];
      };

    };
}
