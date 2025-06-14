{
  wayland.windowManager.sway.config = {
    defaultWorkspace = "1";
    workspaceOutputAssign = [
      {
        output = [
          "Philips Consumer Electronics Company PHL 272B4Q AU11526001821" # Main screen office
          "AOC 2460G4 0x0000A8E2" # Main screen home
          "eDP-2" # Framework Laptop Screen
        ];

        workspace = "1";
      }

      {
        output = [
          "Philips Consumer Electronics Company PHL 272B4Q AU11531001040" # Second screen office
          "Acer Technologies RT240Y T75EE0042411" # Second Screen home
        ];

        workspace = "2";
      }

      # Laptop screen should own workspace 4 and 5 when its docked
      # When at home/not using the laptop screen, these workspaces should be assigned to the secondary screen
      { output = [ "eDP-2" "Acer Technologies RT240Y T75EE0042411" ]; workspace = "3"; }
      { output = [ "eDP-2" "Acer Technologies RT240Y T75EE0042411" ]; workspace = "4"; }
    ];
  };
}