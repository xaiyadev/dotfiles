{ osConfig, lib, ... }:
let
  # inherit (lib) toString;

  keyboard = osConfig.sylveon.hardware.inputs.keyboard;
  mouse = osConfig.sylveon.hardware.inputs.mouse;
  touchpad = osConfig.sylveon.hardware.inputs.touchpad;
in
{

  wayland.windowManager.sway.config = {
    input = {

      # All input devices
      "*" = {
        xkb_layout = keyboard.layout;

        accel_profile = "flat";
        pointer_accel = builtins.toString mouse.accelSpeed;
      };

      # Framework 16 touchpad
      "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
	pointer_accel = builtins.toString touchpad.accelSpeed;

        natural_scroll = if touchpad.naturalScroll then "enabled" else "disabled";
        dwt = if touchpad.disableWhileTyping then "enabled" else "disabled";
      };

    };
  };
}
