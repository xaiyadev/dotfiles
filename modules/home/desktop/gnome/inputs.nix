{ osConfig, lib, ... }:
let

  keyboard = osConfig.sylveon.hardware.keyboard.layout;
  mouse = osConfig.sylveon.hardware.mouse;
  touchpad = osConfig.sylveon.hardware.touchpad;
in
{
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = mouse.accelProfile;
      speed = -0.7; # mouse.accelSpeed;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      accel-profile = touchpad.accelProfile;
      speed = -0.7; # touchpad.accelSpeed;

      natural-scroll = touchpad.naturalScroll;
      disable-while-typing = touchpad.disableWhileTyping;
    };

    "org/gnome/desktop/input-sources".sources = [ "xkb_layout" "de" ];
  };
}