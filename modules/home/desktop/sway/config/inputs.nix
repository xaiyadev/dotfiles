{ osConfig, lib, ... }:
let
  # inherit (lib) toString;

  keyboard = osConfig.sylveon.hardware.keyboard.layout;
  mouse = osConfig.sylveon.hardware.mouse;
  touchpad = osConfig.sylveon.hardware.touchpad;
in
{

  wayland.windowManager.sway.config = {
    input = {
      # All input devices
      "*" = {
        xkb_layout = "de";

        accel_profile = mouse.accelProfile;
        # pointer_accel = toString mouse.accelSpeed;
        pointer_accel = "-0.7";
      };

      # Framework 16
      "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
        pointer_accel = "-0.7"; # builtins.toString touchpad.accelSpeed;

        natural_scroll = if touchpad.naturalScroll then "enabled" else "disabled";
        dwt = if touchpad.disableWhileTyping then "enabled" else "disabled";
      };
    };
  };
}