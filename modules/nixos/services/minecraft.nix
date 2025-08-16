{ pkgs, config, lib, self, ... }:
let
  inherit (self.lib.modules) mkPackageOpt;

  inherit (lib.modules) mkIf;
  cfg = config.sylveon.services.minecraft;
in
{

  options.sylveon.services.minecraft = 
    mkPackageOpt pkgs.papermcServers.papermc "Minecraft Server as Service";

  config = {
    services.minecraft-server =  mkIf cfg.enable {
      enable = true;
      inherit (cfg) package;

      eula = true;
      openFirewall = true;
    
      declarative = true;
      whitelist = {
        # Mine minecraft account
        xaiyadev = "46fbfb38-95fe-4065-8391-42b33d938b15";
    
      };
    
      serverProperties = {
        dificulty = 3;
        gamemode = 0;
    
        white-list = true;
        motd = "Sylveon Network";
      };
    
      jvmOpts = "-Xms4092M -Xmx4092M";
    };
  };
}
