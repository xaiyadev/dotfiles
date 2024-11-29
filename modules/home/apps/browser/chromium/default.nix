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
with lib.${namespace};
let
    cfg = config.${namespace}.apps.browser.chromium;
in
{
  options.${namespace}.apps.browser.chromium = with types; {
      enable = mkBoolOpt false "Wheter or not to enable the chromium browser";
      # TODO: add extra extensions option
  };

  /**
    This code will be removed after the zen browser is offically released and there is a module for it
    Until then, this is just a alternative

    For more information reffer to the zen module
   */
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override { enableWideVine = true; }; # This allows chromium to stream DRM content (only 720p tho :/)

      extensions = [
        # The default extensions I use for chromium
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "oldceeleldhonbafppcapldpdifcinji"; } # Language Tool
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      ];

      # Use German and Englisch as the default language in chromium
      dictionaries = with pkgs.hunspellDictsChromium; [ en_US de_DE ];
    };
  };
}
