let
  name = "docked_office";
  office_screen_1 = "Philips Consumer Electronics Company PHL 272B4Q";
  office_screen_2 = "LG Electronics LG ULTRAFINE";
in
{
  services.kanshi.settings = [
    /* --- Configuration of Office desks --- */
    # TODO: generalization of desktops needed

    # Desk 1 (Xaiya)
    {
      profile = {
        inherit name;
        outputs = [
          { criteria = "$enabled_internal"; }

          {
            criteria = "${office_screen_1} ULTRAFINE AU11526001821";             
            position = "2560,80";

            mode = "2560x1440@59.951Hz";
          }

          {
            criteria = "${office_screen_1} ULTRAFINE AU11531001040";             
            position = "5120,160";

            mode = "2560x1440@59.951Hz";
          }
        ];
      };
    }

    # Desk 2
    {
      profile = {
        name = "${name}_2";
        outputs = [
          {
            criteria = "$enabled_internal";
            position = "4627,489";
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 203NTXR8L890";
            position = "1666,651";

            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 203NTFA8L891";
            transform = "90";


            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }
        ];
      };
    }

    # Desk 3
    {
      profile = {
        name = "${name}_3";
        outputs = [
          {
            criteria = "$enabled_internal";
            position = "5922,0";
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 404NTGY9M335";
            position = "2961,555";


            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 404NTYT9M282";
            position = "0,555";


            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }
        ];
      };
    }

    # Desk 4
    {
      profile = {
        name = "${name}_4";
        outputs = [
          {
            criteria = "$enabled_internal";
            position = "6000,623";
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 203NTUW9S734";
            position = "2160,701";

            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }

          {
            criteria = "${office_screen_2} HDR 4K 0x0009ED6F";

            transform = "90";
            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }
        ];
      };
    }

    # Desk 5
    {
      profile = {
        name = "${name}_5";
        outputs = [
          {
            criteria = "$enabled_internal";
            position = "6000,258";
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 406NTYT13970";
            position = "2160,626";

            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 406NTRL13990";
            transform = "90";

            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }
        ];
      };
    }

    # Desk 6 (Fynn)
    {
      profile = {
        name = "${name}_6";
        outputs = [
          {
            criteria = "$enabled_internal";
            position = "0,206";
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 402NTQD4R396";
            position = "2560,385";

            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }

          {
            criteria = "${office_screen_2} ULTRAFINE 402NTNH4R311";
            transform = "270";
            position = "6400,0";

            mode = "3840x2160@60.000Hz";
            scale = 1.2;
          }
        ];
      };
    }
  ];
}
