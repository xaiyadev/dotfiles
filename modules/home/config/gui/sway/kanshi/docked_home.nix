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
        ];
      };
    }
  ];
}
