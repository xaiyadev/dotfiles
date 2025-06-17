{
  services.kanshi.settings = [
    {
      profile = {
        name = "docked_office";
        outputs = [
          {
            criteria = "eDP-2";

            position = "4627,489";
            mode = "2560x1600@165.000Hz";
          }

          {
            criteria = "LG Electronics LG ULTRAFINE 203NTXR8L890";

            position = "1666,651";
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "LG Electronics LG ULTRAFINE 203NTFA8L891";

            transform = "90";
            position = "0,0";
            mode = "3840x2160@60.000Hz";
          }
        ];
      };
    }
  ];
}
