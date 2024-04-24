{ pkgs, ... }: {
    services.xserver = {
        enable = true;

        displayManager.sddm.enable = true;
        windowManager.qtile.enable = true;

        layout = "de";
        xkbVariant = "";
    };
}
