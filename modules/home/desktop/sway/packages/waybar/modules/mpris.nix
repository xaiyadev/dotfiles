{ pkgs, ... }: {

  home.packages = [
    pkgs.playerctl # used by MPRIS
  ];

  programs.waybar.settings.mainBar = {
    "mpris" = {
      interval = 1;
      max-length = 80;
      player = "chromium"; # Tidal-hifi is based on chromium

    	format = "{player_icon} {title} <i>({position}/{length})</i>";
      format-paused = "{status_icon} {title} <i>({position}/{length})</i>";

    	player-icons.default = " ";
    	status-icons.paused = " ";
    };

    "custom/weather" = {
      format = "{}°";

      tooltip = true;
      interval = 1800; /* 30min */

      exec = "${pkgs.wttrbar}/bin/wttrbar";
      return-type = "json";
    };
  };
}