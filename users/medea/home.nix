{ pkgs, config, ... }: {
       home.username = "medea";
       home.homeDirectory = "/home/medea";

       programs.chromium.enable = true;
	   home.packages = with pkgs; [
	        zoom-us
	        onlyoffice-bin
       ];

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}