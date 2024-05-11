{ pkgs, ... }: {
    services.xserver = {
        enable = true;

        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        xkb = {
        layout = "de";
        variant = "";
        };
    };

    environment.gnome.excludePackages = (with pkgs; [
        gnome-photos
        gnome-tour
    ]) ++ (with pkgs.gnome; [
        cheese
        gnome-music
        epiphany
        evince
        totem
        tali
        iagno
        hitori
        atomix
    ]);


    environment.systemPackages = with pkgs; [
        gnome.gnome-tweaks
        gnome-extension-manager

        gnomeExtensions.weather-oclock
        gnomeExtensions.open-bar
    ];
}
