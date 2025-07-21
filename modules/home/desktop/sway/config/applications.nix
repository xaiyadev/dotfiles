{ pkgs, ... }:
{
  wayland.windowManager.sway.config = {
    window = {
      border = 3;
      titlebar = false;
    };
    gaps = {
      inner = 5;
    };

    floating = {
      # Windows that should be opened in floating mode
      criteria = [
        { class = "tidal-hifi"; }

        # Steam Windows
        { title = "Steam Settings"; }
        { title = "Friends List"; }

        { class = "Enpass"; }
        { app_id = "yubioath-flutter"; }

        { app_id = ".blueman-manager-wrapped"; }
        { app_id = "org.pulseaudio.pavucontrol"; }

        { app_id = "org.gnome.Calculator"; }
        { app_id = "org.gnome.Calendar"; }
        { app_id = "org.gnome.TextEditor"; }

        { app_id = "org.gnome.Nautilus"; }
        { app_id = "nemo"; }

        { app_id = "org.prismlauncher.PrismLauncher"; }
      ];
    };

    assigns = {
      "1" = [ { class = "^jetbrains"; } ];
      "2" = [ { app_id = "librewolf"; } ];
      "4" = [
        { class = "discord"; }
        { class = "teams-for-linux"; }
      ];
    };

    startup = [
      { command = "${inputs'.nixcord.packages.discord}/bin/discord"; }
      { command = "${pkgs.teams-for-linux}/bin/teams-for-linux"; }
    ];

  };
}
