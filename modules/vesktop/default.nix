{pkgs, ...}: {
    home.packages = with pkgs; [
        vesktop
    ];

    home.file.".config/vesktop/settings.json".source = config/settings.json;
    home.file.".config/vesktop/settings/quickCss.css".source = config/settings/quickCss.css;
    home.file.".config/vesktop/settings/settings.json".source = config/settings/settings.json;


}