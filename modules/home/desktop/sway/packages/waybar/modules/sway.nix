{
  programs.waybar.settings.mainBar = {

    "sway/window".format = "{title}";

    # Show the sway workspaces in your waybar
    "sway/workspaces" = {
      disable-scroll = true;
      all-outputs = true;

      format = "{icon}";

      format-icons = {
        "1" = " ";
        "2" = " ";
        "3" = " ";
        "4" = "󰕘 ";
        "5" = "󱝁 ";
        "6" = " ";
        "7" = " ";
        "8" = " ";
        "9" = "󱕅 ";
        "10" = " ";
        sort-by-number = true;
      };
    };
  };
}
