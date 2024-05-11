{ ... }: {
    /* As long as the theme is one file, I use home.config */
    home.file.".themes/BreakingCustomShell/gnome-shell/gnome-shell.css".source = ./BreakingCustomShell/gnome-shell/gnome-shell.css;


    dconf = {
        enable = true;
        settings."org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";

        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        settings."org/gnome/desktop/background".primary-color = "#B2B2B2";
        settings."org/gnome/desktop/background".secondary-color = "#000000";

        settings."org/gnome.shell/extensions/user-theme".name = "BreakingCustomShell";

        settings."org/gnome/desktop/background".picture-ui = "file:///home/semiko/.config/nixos/wallpapers/wallpaper-1.png";

    };
}
