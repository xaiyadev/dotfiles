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
            criteria = "Acer Technologies RT240Y T75EE0042411";
            position = "1831,0";

            mode = "1920x1080@60.000Hz";
          }

          {
             criteria = "eDP-2";
             position = "0,0";

             mode = "2560x1600@165.000Hz";
             scale = 1.4;
          }

        ];
      };
    }
  ];
}
