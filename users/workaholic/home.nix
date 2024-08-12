{ pkgs, config, ... }: {
   home.username = "workaholic";
   home.homeDirectory = "/home/workaholic";

   imports = [
     # --- CORE --- #
     ../../modules/core/git

     # --- APPS --- #
     ../../modules/apps/spotify
     ../../modules/apps/vesktop
     ../../modules/apps/chromium

     ../../modules/apps/jetbrains/phpstorm
     ../../modules/apps/virt-manager

     # -- CONFIG LOADER -- #
     ../../modules/apps/desktop/environment/gnome-config
   ];

    home.packages = with pkgs; [
          teams-for-linux
	      enpass
    ];
   services.spotify.enable = true;
   services.chromium.enable = true;
   services.vesktop.enable = true;

   services.phpstorm.enable = true;


   services.git = {
        enable = true;
        email = "d.schumin@blmedia.de";
   };

   services.gnome-config.enable = true;


   home.stateVersion = "23.11";
   programs.home-manager.enable = true;
}
