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
    cfg = config.${namespace}.desktop.sddm;

    extraEnv = 
    {
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    swayEntry = pkgs.writeTextFile {
      name = "sway.desktop";
      destination = "/share/wayland-sessions/sway.desktop";
      text = ''
        [Desktop Entry]
        Name=sway
        Comment=Startup sway
        Exec=${pkgs.sway}/bin/sway --unsupported-gpu
        Type=Application
      '';
      checkPhase = ''${pkgs.buildPackages.desktop-file-utils}/bin/desktop-file-validate "$target"'';
      derivationArgs = { passthru.providedSessions = [ "sway" ]; };
    };
in
{
    options.${namespace}.desktop.sddm = {
        enable = mkEnableOption "Activate the SDDM displayManager";
    };


    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
          vulkan-tools
          glxinfo
          glmark2
      ];
      
      environment.variables = extraEnv;
      environment.sessionVariables = extraEnv;

      services.displayManager = {
        sddm = {
          enable =  true;
          wayland.enable = true;
        };
        sessionPackages = [ swayEntry ];
      };

    };
}
