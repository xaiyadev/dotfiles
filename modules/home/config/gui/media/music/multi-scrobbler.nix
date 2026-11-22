{ lib, pkgs, config, osConfig, ... }:
let
  cfg = config.sylveon.programs;
in {
  # if sone is installed also install the scrobbler
  config = lib.mkIf (cfg.music-players != null && builtins.elem "tidal" cfg.music-players) {
    systemd.user.services.multi-scrobbler = {
      Unit = {
        Description = "multi-scrobbler: SONE (MPRIS) -> teal.fm";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe pkgs.multi-scrobbler;
        Environment = [
          "TEALFM_IDENTIFIER=xaiya.dev"
          "TEALFM_ID=tealfm"

          "MPRIS_ID=sone"
          "MPRIS_WHITELIST=sone"
          "MPRIS_TRANSFORMS=native"            # splits given artists into an array

          # if both users are logged in it could give out an error
          #  TODO: if possible; do this with other users too? More global solution
          "PORT=${if config.home.username == "xaiya" then "9078" else "9079"}"

          "CONFIG_DIR=%S/multi-scrobbler"
        ];
        EnvironmentFile = osConfig.age.secrets."multi-scrobbler-env".path;
        StateDirectory = "multi-scrobbler";
        Restart = "on-failure";
        RestartSec = 10;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
