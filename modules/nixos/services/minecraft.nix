{ pkgs, config, lib, self, ... }:
let
  inherit (self.lib.modules) mkPackageOpt;

  inherit (lib.modules) mkIf;
  cfg = config.sylveon.services.minecraft;
in
{

  options.sylveon.services.minecraft = 
    mkPackageOpt pkgs.papermcServers.papermc "Minecraft Server as Service";

  config = mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      inherit (cfg) package;

      # What world I want to use
      dataDir = "/mnt/raid/Xaiya/minecraft/01";

      eula = true;
      openFirewall = true;
    
      declarative = true;
      whitelist = {
        xaiyadev = "46fbfb38-95fe-4065-8391-42b33d938b15"; # me :>
        DerHirschGamer = "91142f92-dba4-4a3b-806a-bea7983c5f70"; # Timo
        _MarinoO_ = "647358b5-9d8b-443c-8287-65fef3a64862"; # Marin
        LeoLikesTurtles = "f605a6d7-7066-4c8b-93b7-2fa7bcf91918"; # Leo
        Suprice30 = "a7faf45a-0673-4be0-bb7c-2bcdfc9bbace"; # David
        Pallgamer48 = "5942cf47-3c62-4286-bd1e-1d58d42deed5"; # Jane
        ein_fish2punkt0 = "a97c9751-8458-45df-b58a-4dd1c1e027c2"; # Richie
        Cobbeled = "ca1baad9-2168-4a8f-bdaf-d612f7569ace"; # Cobble
      };
    
      serverProperties = {
        dificulty = 3;

        gamemode = 0;
        force-gamemode = true;

        max-players = 10;
        view-dance = 32;
    
        white-list = true;
        motd = "Sylveon Network";
      };
    
      jvmOpts = "-Xms4092M -Xmx4092M";
    };
  };
}
