{
  services.kanshi.settings = [
    {
      profile = {
        name = "docked_home";
        outputs = [
          { criteria = "eDP-2"; status = "disable"; }

          {
            criteria = "AOC 2460G4 0x0000A8E2";
            position = "1920,80";

            mode = "1920x1080@119.982Hz";
          }

          {
            criteria = "Acer Technologies RT240Y T75EE0042411";

            position = "0,0";
            mode = "1920x1080@60.000Hz";
          }
        ];
      };
    }
  ];
}
