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

  osConfig,
  config,
  specialArgs,
  ...
}:
with lib;
with lib.${namespace};
let
    cfg = config.${namespace}.apps.music.spotify;
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.${namespace}.apps.music.spotify = with types; {
      enable = mkBoolOpt false "Whether or not to enable the spotify application";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      # Enable rose-pine Theming
      theme = spicePkgs.themes.ziro;
      colorScheme = "rose-pine";

      # Install all the extensions I use
      enabledExtensions = with spicePkgs.extensions; [
        showQueueDuration
        betterGenres
      ];
    };

    # Add Spotify to the automatic startup
    wayland.windowManager.sway.config.startup = mkIf osConfig.${namespace}.desktop.sway.enable [
      # Startup Spotify and wait for it to startup, then move it to workspace 4
      { command = ''exec spotify''; }
      { command = ''sleep 5 && sway '[class="Spotify"]' move container to workspace 4 ''; }
    ];
  };
}
