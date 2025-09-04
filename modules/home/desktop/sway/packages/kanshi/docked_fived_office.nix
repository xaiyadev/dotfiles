{
  services.kanshi.settings = [
    {
      profile = {
        name = "docked_office_fived";
        outputs = [
          {
            criteria = "eDP-2";

            position = "6000,258";
            mode = "2560x1600@165.000Hz";
          }

          {
            criteria = "LG Electronics LG ULTRAFINE 406NTYT13970";

            position = "2160,626";
            mode = "3840x2160@60.000Hz";
          }

          {
            criteria = "LG Electronics LG ULTRAFINE 406NTRL13990";

            transform = "90";
            position = "0,0";
            mode = "3840x2160@60.000Hz";
          }
        ];
      };
    }
  ];
}
