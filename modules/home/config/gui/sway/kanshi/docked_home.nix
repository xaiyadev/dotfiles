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
            criteria = "AOC 2460G4 0x0000A8E2";

            mode = "1920x1080@119.982Hz";
            position = "0,475";
          }

          {
            criteria = "Acer Technologies RT240Y T75EE0042411";

            position = "1920,0";

            transform = "90";
            mode = "1920x1080@60.000Hz";
          }

          {
            criteria = "eDP-2";
            status = "disable";
          }
        ];
      };
    }

    {
      profile = {
        name = "${name}--single_screen";

        outputs = [
          {
            criteria = "AOC 2460G4 0x0000A8E2";

            mode = "1920x1080@119.982Hz";
            position = "2560,266";
          }

          {
            criteria = "eDP-2";
            position = "5120,0";

            mode = "2560x1600@165.000Hz";
            scale = 1.3;
          }
        ];
      };
    }
  ];
}
