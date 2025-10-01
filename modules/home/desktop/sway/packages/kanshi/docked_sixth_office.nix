{
  services.kanshi.settings = [
    {
      profile = {
        name = "docked_office_fived";
        outputs = [
          {
            criteria = "eDP-2";

            position = "0,206";
            mode = "2560x1600@165.000Hz";
          }

          {
            criteria = "LG Electronics LG ULTRAFINE 402NTQD4R396";

            position = "2560,385";
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "LG Electronics LG ULTRAFINE 402NTNH4R311";

            transform = "270";
            position = "6400,0";
            mode = "3840x2160@60.000Hz";
          }
        ];
      };
    }
  ];
}
