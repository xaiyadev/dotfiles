{
  name = "Overview";
  hide-desktop-navigation = true;
  center-vertically = true;

  head-widgets = [
    (import ./widgets/search.nix)
  ];

  columns = [
    {
      size = "small";
      widgets = [
        (import ./widgets/calendar.nix)
        (import ./widgets/clock.nix)
        (import ./widgets/weather.nix)
      ];
    }

    {
      size = "full";
      widgets = [
        {
          type = "group";
          widgets = [
            (import ./widgets/monitor.nix)
            (import ./widgets/mcstats.nix)
          ];
        }

        (import ./widgets/trendingRepositories.nix)
      ];
    }

    {
      size = "small";
      widgets = [
        (import ./widgets/recentListens.nix)
        (import ./widgets/releases.nix)
        (import ./widgets/serverStats.nix)
        (import ./widgets/tailscaleDevices.nix)
      ];
    }
  ];
}
