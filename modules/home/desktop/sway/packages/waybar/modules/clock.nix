{ pkgs, ...}: {
  programs.waybar.settings.mainBar = {
    /* Show the current time (change formating here...) */
    "clock" = {
      interval = 60;
      on-click = "${pkgs.gnome-calendar}/bin/gnome-calendar";

      timezone = "Europe/Berlin";
      locale = "de_DE.UTF-8";
      format = "󱑅  {:%H:%M}";
    };
  };
}