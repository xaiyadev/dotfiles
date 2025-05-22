{ osConfig, lib, ... }:
let
  inherit (lib.gvariant) mkTuple;

  keyboard = osConfig.sylveon.hardware.inputs.keyboard;
  mouse = osConfig.sylveon.hardware.inputs.mouse;
  touchpad = osConfig.sylveon.hardware.inputs.touchpad;
in
{
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = mouse.accelProfile;
      speed = mouse.accelSpeed;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      accel-profile = touchpad.accelProfile;
      speed = touchpad.accelSpeed;

      natural-scroll = touchpad.naturalScroll;
      disable-while-typing = touchpad.disableWhileTyping;
    };

    "org/gnome/desktop/input-sources".sources =
      [
        (mkTuple [ "xkb" keyboard.layout ])
      ];
  };
}