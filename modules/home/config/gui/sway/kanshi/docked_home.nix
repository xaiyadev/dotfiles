let
  name = "docked_home";
in
{
  services.kanshi.settings = [
    {
      profile = {
        inherit name;

        outputs = [
          {
            criteria = "AOC CQ32G4 RK3S5JA005767";
            position = "2327,0";

            mode = "2560x1440@144.001Hz";
          }

          {
            criteria = "Acer Technologies RT240Y T75EE0042411";
            position = "4887,360";

            mode = "1920x1080@60.000Hz";
          }

          {
            criteria = "eDP-2";
            position = "0,0";

            mode = "2560x1600@165.000Hz";
            scale = 1.1;
          }

        ];
      };
    }
  ];
}
