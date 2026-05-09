{
  lib,
  osConfig,
  pkgs,
  inputs',
  ...
}:
let
  inherit (lib) mkIf mkMerge;

  prof = osConfig.sylveon.profiles;
in
{
  sylveon.packages = mkMerge [
    (mkIf prof.graphical.enable {
      inherit (pkgs)
        gnome-calendar
        teams-for-linux # Needed for all graphical users currently TODO change when leaving school
        obsidian # TODO
        ;

      inherit (inputs'.tidaLuna.packages) default;
    })

    (mkIf prof.gaming.enable {
      inherit (pkgs)
        gamescope # TODO
        prismlauncher # TODO
        deadlock-mod-manager # TODO
        ;
    })

    {
      inherit (pkgs)
        vim # TODO neovim config
        devenv
        ;
    }
  ];
}
