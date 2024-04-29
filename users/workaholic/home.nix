{ pkgs, config, ... }: {

       imports = [
            ../../modules/programs/git.nix
       ];

       services.git = {
         enable = true;
         service = "bitbucket";
       };

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
