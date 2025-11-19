{ config, lib, ... }:
let
  hour-format = "24h";
in
{
  name = "Overview";
  hide-desktop-navigation = true;
  center-vertically = true;

  head-widgets = [
    { type = "search"; autofocus = true; } 
  ];

  columns = [
    {
      size = "small";
      widgets = [
        { type = "calendar"; }

        {
          type = "clock";
          inherit hour-format;
        }

        {
          type = "weather";
          location = "Berlin, Germany"; # TODO: automate based on server location

          inherit hour-format;
        }
      ];
    }

    {
      size = "full";
      widgets = [ (import ./widgets/monitor.nix { config = config; lib = lib; } ) ];
    }

    {
      size = "small";
      widgets = [
        (import ./widgets/recentListens.nix)

        {
          type = "releases";
          show-source-icon = true;
          repositories = [ # TODO: add a connection to this flakes knot
            "WillPower3309/swayfx"
            "Inrixia/TidaLuna"
          ];
        }

        (import ./widgets/serverStats.nix { config = config; lib = lib; })
        (import ./widgets/tailscaleDevices.nix)
      ];
    }
  ];
}
