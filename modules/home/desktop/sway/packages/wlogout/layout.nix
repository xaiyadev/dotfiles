{ pkgs, ... }: {
  programs.wlogout.layout = [
    {
      label = "shutdown";
      action = "${pkgs.systemd}/bin/systemctl poweroff";
      text = "Shutdown";
      keybind = "s";
    }

    {
      label = "reboot";
      action = "${pkgs.systemd}/bin/systemctl reboot";
      text = "Reboot";
      keybind = "r";
    }

    {
      label = "logout";
      action = "${pkgs.systemd}/bin/loginctl kill-session $XDG_SESSION_ID";
      text = "Logout";
      keybind = "e";
    }

    {
      label = "lock";
      action = "${pkgs.swaylock-effects}/bin/swaylock";
      text = "Lock";
      keybind = "l";
    }
  ];
}