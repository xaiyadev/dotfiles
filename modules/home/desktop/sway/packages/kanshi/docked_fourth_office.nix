{
  services.kanshi.settings = [
    {
      profile = {
        name = "docked_office_fourth";
        outputs = [
          {
            criteria = "eDP-2";

            position = "6000,623";
            mode = "2560x1600@165.000Hz";
          }

          {
            criteria = "LG Electronics LG ULTRAFINE 203NTUW9S734";

            position = "2160,701";
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "LG Electronics LG HDR 4K 0x0009ED6F";

            transform = "90";
            position = "0,0";
            mode = "3840x2160@60.000Hz";
          }
        ];
      };
    }
  ];
}
