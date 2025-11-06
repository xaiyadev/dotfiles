{
  wayland.windowManager.sway.config = {
    defaultWorkspace = "1";

    workspaceOutputAssign = [
      {
        output = [
          # Office Screens
          "Philips Consumer Electronics Company PHL 272B4Q AU11531001040"
          "LG Electronics LG ULTRAFINE 203NTXR8L890"

          # Private Screens
          "AOC 2460G4 0x0000A8E2"

          # Internal Screen
          "eDP-2"
        ];

        workspace = "1";
      }

      {
        output = [
          # Office Screens
          "Philips Consumer Electronics Company PHL 272B4Q AU11526001821"
          "LG Electronics LG ULTRAFINE 203NTFA8L891"

          # Private Screens
          "Acer Technologies RT240Y T75EE0042411"
        ];

        workspace = "2";
      }

      # Laptop screen should own workspace 4 and 5 when its docked
      # if the laptop screen is not available, use the default second screens
      # TODO: automate this process
      {
        output = [
          "eDP-2"

          "Acer Technologies RT240Y T75EE0042411"
          "Philips Consumer Electronics Company PHL 272B4Q AU11526001821"
        ];
        workspace = "3";
      }

      {
        output = [
          "eDP-2"

          "Acer Technologies RT240Y T75EE0042411"
          "Philips Consumer Electronics Company PHL 272B4Q AU11526001821"
        ];
        workspace = "4";
      }
    ];
  };
}
