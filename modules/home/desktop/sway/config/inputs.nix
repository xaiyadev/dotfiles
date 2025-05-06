{
  wayland.windowManager.sway.config = {
    input = {
      # All input devices
      "*" = {
        xkb_layout = "de";

        accel_profile = "flat";
        pointer_accel = "-0.7";
      };

      # Framework 16
      "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
        pointer_accel = "0.2";
        natural_scroll = "enabled";

        dwt = "enabled";
        tap = "enabled";
        middle_emulation = "enabled";
      };
    };
  };
}