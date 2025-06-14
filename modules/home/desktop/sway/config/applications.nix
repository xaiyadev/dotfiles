{ pkgs, ... }: {
  wayland.windowManager.sway.config = {
    window = { border = 2; titlebar = false; };
    gaps = { inner = 5; };

    floating = {
      # Windows that should be opened in floating mode
      criteria = [
        { class = "tidal-hifi"; }
        { title = "Steam Settings"; }
        { class = "Enpass"; }
      ];
    };

    assigns = {
      "1" = [{ class = "^jetbrains"; }];
      "2" = [{ app_id = "librewolf"; }];
      "3" = [{ class = "tidal-hifi"; }];
      "4" = [ { class = "vesktop"; } { class = "teams-for-linux"; } ];
    };

    startup = [
      { command = "${pkgs.librewolf}/bin/librewolf"; }
      { command = "${pkgs.vesktop}/bin/vesktop"; }
      { command = "${pkgs.teams-for-linux}/bin/teams-for-linux"; }
    ];

  };
}