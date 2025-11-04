{
  wayland.windowManager.sway.config = {
    defaultWorkspace = "1";

    workspaceOutputAssign = [
      {
        output = [
          "Philips Consumer Electronics Company PHL 272B4Q AU11526001821"
          "LG Electronics LG ULTRAFINE 203NTXR8L890"
          "LG Electronics LG ULTRAFINE 404NTGY9M335"
          "LG Electronics LG ULTRAFINE 406NTYT13970"
          "LG Electronics LG ULTRAFINE 402NTQD4R396"
          "AOC 2460G4 0x0000A8E2"

          "eDP-2"
        ];

        workspace = "1";
      }

      {
        output = [
          "Philips Consumer Electronics Company PHL 272B4Q AU11531001040"
          "LG Electronics LG ULTRAFINE 203NTFA8L891"
          "LG Electronics LG ULTRAFINE 402NTNH4R311"
          "LG Electronics LG ULTRAFINE 404NTYT9M282"
          "LG Electronics LG ULTRAFINE 406NTRL13990"
          "Acer Technologies RT240Y T75EE0042411"
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
