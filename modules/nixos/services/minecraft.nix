{
  pkgs,
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.lib.modules) mkOpt;
  inherit (lib.modules) mkIf;
  inherit (lib.types) bool package;

  cfg = config.sylveon.services.minecraft;
in
{

  options.sylveon.services.minecraft = {
    enable = mkOpt bool false "Enable a Minecraft server";
    package = mkOpt package pkgs.papermcServers.papermc-1_21_9 "On what package this server should be based on";
  };

  config = mkIf cfg.enable {

    # Open Minecraft port and proximity port
    networking.firewall = {
      allowedUDPPorts = [ 24454 25565 ];
      allowedTCPPorts = [ 24454 25565 ];
    };

    services.minecraft-server = {
      enable = true;
      inherit (cfg) package;

      # What world I want to use (TODO: needs some changes)
      dataDir = "/mnt/raid/services/minecraft/02";

      eula = true;
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
        juijui0986 = "20a91ac9-e8fc-4032-b135-3c1550071a09"; # juijui
        NeyroHD = "5f4b3403-9226-40a0-897a-fc545d039a95"; # Finn
        m1Kaz1lla = "7bb7448c-8180-44de-bae4-bfe4b4f406bb"; # Mika
        mythicalel = "6c99fe8f-8565-4781-ac1d-62121e6953e5"; # Phillip
        M0rganite1 = "e8d654c9-6bd4-4572-b409-75e6a387f759"; # Leana
        RosaKanickel = "613a8b60-c834-47d7-bff8-586d7681bb4c"; # Lennard
      };

      serverProperties = {
        difficulty = "hard";
        spawn-protection = 0;

        gamemode = 0;
        force-gamemode = true;

        max-players = 10;
        view-dance = 18;
        simulation-distance = 8;

        white-list = true;
        motd = "Sylveon Network";
      };

      jvmOpts = "-Xms2G -Xmx8G";
    };
  };
}
