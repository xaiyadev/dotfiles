{ pkgs, config, ... }: {
       home.username = "workaholic";
       home.homeDirectory = "/home/workaholic";

        home.packages = with pkgs; [
              jetbrains.phpstorm
              teams-for-linux
              enpass
              thunderbird
        ];

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}