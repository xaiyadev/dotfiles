{ lib, pkgs, config, ... }:
{
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

   imports = [
        # --- CORE --- #
        ../../modules/core/git
    ];

   services.git = {
        enable = true;
        email = "danil80sch@gmail.com";
   };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}