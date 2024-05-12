{ pkgs, config, ... }: {
       home.username = "oksana";
       home.homeDirectory = "/home/oksana";

       programs.chromium.enable = true;
	
	   home.packages = with pkgs; [
	        zoom-us
	        onlyoffice-bin
       ];

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}
