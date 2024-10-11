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

      /* Packages and other things that need to be installed */
      services.gnome.gnome-keyring.enable = true;
      services.dbus.enable = true;

      environment.systemPackages = with pkgs; [
        wayland
        xdg-utils
        glib
        grim
        slurp
        wl-clipboard
        mako
        dbus

        swayfx
      ];


      /* Desktop and window manager thingies */
      services.xserver = {
      	enable = true;
      };
      services.displayManager = {
        sddm = {
          enable =  true;
          wayland.enable = true;
        };

        sessionPackages = let
         custom-sway = pkgs.writeTextFile {
                   name = "sway.desktop";
                   destination = "/share/wayland-sessions/sway.desktop";
                   text = ''
                    [Desktop Entry]
                    Comment=Fuck. You. Nvidia.
                    Exec=${pkgs.swayfx}/bin/sway --unsupported-gpu
                    Name=custom-sway
                    Type=Application
                   '';
                   checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
                   derivationArgs = { passthru.providedSessions = [ "sway" ]; };
                 };
         in [ custom-sway ];
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      # Required for Sway as per https://nixos.wiki/wiki/Sway
      security.polkit.enable = true;

/*      programs.sway = {
	      enable = true;
	      package = pkgs.swayfx;

	      wrapperFeatures.gtk = true;

        # Add Unsupported GPUs for huckleberry // nvidia devices
	      extraOptions = [
	        "--unsupported-gpu"
	      ];

	      extraSessionCommands = ''
          export WLR_RENDERER=vulkan
	      '';
      };*/
    };
}
