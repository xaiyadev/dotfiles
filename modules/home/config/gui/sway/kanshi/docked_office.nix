let
  name = "docked_office";
  office_screen_1 = "Philips Consumer Electronics Company PHL 272B4Q";
  office_screen_2 = "LG Electronics LG";
in
{
  services.kanshi.settings = [
    # TODO: generalization of desktops needed

    # Desk 1 (Xaiya)
    {
      profile = {
        inherit name;
        outputs = [          

          {
            criteria = "${office_screen_1} 0x00000410";
            position = "2560,0";

            mode = "2560x1440@59.951Hz";
          }

          {
            criteria = "${office_screen_1} AU11526001821";             
            position = "0,81";

            mode = "2560x1440@59.951Hz";
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

    # Desk 2 (Dominik)
    {
      profile = {
        name = "${name}-dthoene";
        outputs = [
          {
            criteria = "${office_screen_2} ULTRAFINE 203NTXR8L890";
            position = "1801,699";

            scale = 1.2;
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 203NTFA8L891";
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
        name = "${name}-elvis";
        outputs = [
          {
            criteria = "${office_screen_2} ULTRAFINE 404NTGY9M335";
            position = "2560,132";

            scale = 1.2;
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 404NTYT9M282";
            position = "5762,132";

            scale = 1.2;
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
