{
  wayland.windowManager.sway.config = {
    defaultWorkspace = "1";

    # Change screen DPI/scaling
    output = {
      "LG Electronics LG ULTRAFINE 203NTXR8L890" = {
        scale = "1.3";
      };
      "LG Electronics LG ULTRAFINE 203NTFA8L891" = {
        scale = "1.3";
      };
      "LG Electronics LG ULTRAFINE 404NTGY9M335" = {
        scale = "1.3";
      };
      "LG Electronics LG ULTRAFINE 404NTYT9M282" = {
        scale = "1.3";
      };
      "LG Electronics LG ULTRAFINE 406NTRL13990" = {
        scale = "1.3";
      };
      "LG Electronics LG ULTRAFINE 406NTYT13970" = {
        scale = "1.3";
      };
      "LG Electronics LG ULTRAFINE 402NTNH4R311" = {
        scale = "1.3";
      };
      "LG Electronics LG ULTRAFINE 402NTQD4R396" = {
        scale = "1.3";
      };
    };

    workspaceOutputAssign = [
      {
        output = [
          "Philips Consumer Electronics Company PHL 272B4Q AU11526001821" # Main screen office
          "LG Electronics LG ULTRAFINE 203NTXR8L890" # Main screen office (2nd workplace)
          "LG Electronics LG ULTRAFINE 404NTGY9M335" # Main screen office (3rd workplace)
          "LG Electronics LG ULTRAFINE 406NTYT13970" # Main screen office (5th workplace)
          "LG Electronics LG ULTRAFINE 402NTQD4R396"
          "AOC 2460G4 0x0000A8E2" # Main screen home
          "eDP-2" # Framework Laptop Screen
        ];

        workspace = "1";
      }

      {
        output = [
          "Philips Consumer Electronics Company PHL 272B4Q AU11531001040" # Second screen office
          "LG Electronics LG ULTRAFINE 203NTFA8L891" # Second screen office (2nd workplace)
          "LG Electronics LG ULTRAFINE 402NTNH4R311"
          "LG Electronics LG ULTRAFINE 404NTYT9M282" # Second screen office (3rd workplace)
          "LG Electronics LG ULTRAFINE 406NTRL13990" # Second screen office (5th workplace)
          "Acer Technologies RT240Y T75EE0042411" # Second Screen home

          "eDP-2"
        ];

        workspace = "2";
      }

      # Laptop screen should own workspace 4 and 5 when its docked
      # When at home/not using the laptop screen, these workspaces should be assigned to the secondary screen
      {
        output = [
          "eDP-2"
          "Acer Technologies RT240Y T75EE0042411"
        ];
        workspace = "3";
      }
      {
        output = [
          "eDP-2"
          "Acer Technologies RT240Y T75EE0042411"
        ];
        workspace = "4";
      }
    ];
  };
}
