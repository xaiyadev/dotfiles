let
  name = "docked_office";
  office_screen = "LG Electronics LG";
in
{
  services.kanshi.settings = [
    # Desk 1 (Xaiya)
    # this desk has different screens, therefor no variable
    {
      profile = {
        inherit name;
        outputs = [

          {
            criteria = "Iiyama North America PL2792Q 1152180401975";
            position = "2133,0";

            mode = "2560x1440@59.951Hz";
          }

          {
            criteria = "Iiyama North America PL2792Q 1152184902292";
            position = "4693,0";

            mode = "2560x1440@59.951Hz";
          }

          {
            criteria = "eDP-2";
            position = "0,0";

            mode = "2560x1600@165.000Hz";
            scale = 1.2;
          }

        ];
      };
    }

    # Desk 2 (Dominik)
    {
      profile = {
        name = "${name}-dthoene";
        outputs = [
          {
            criteria = "${office_screen} ULTRAFINE 203NTXR8L890";
            position = "1801,699";

            scale = 1.2;
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "${office_screen} ULTRAFINE 203NTFA8L891";
            position = "0,0";
            transform = "90";

            scale = 1.2;
            mode = "3840x2160@60.000Hz";
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

    {
      profile = {
        name = "${name}-prak";
        outputs = [
          {
            criteria = "${office_screen} HDR 4K 0x0009ED6F";
            position = "2327,98";

            scale = 1.5;
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "Iiyama North America PL2792Q 1152184902292";
            position = "4887,98";

            mode = "2560x1440@59.951";
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

    {
      profile = {
        name = "${name}-elvis";
        outputs = [
          {
            criteria = "${office_screen} ULTRAFINE 404NTGY9M335";
            position = "1968,0";

            scale = 1.5;
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "${office_screen} ULTRAFINE 404NTYT9M282";
            position = "4528,0";

            scale = 1.5;
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "eDP-2";
            position = "0,99";

            mode = "2560x1600@165.000Hz";
            scale = 1.3;
          }
        ];
      };
    }
  ];
}
