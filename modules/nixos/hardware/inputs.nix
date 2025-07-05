{ config, self, lib, ...}:
let
  inherit (lib) mkIf;
  inherit (lib.types) str enum bool float;

  inherit (self.lib.modules) mkOpt;

  theme = config.sylveon.theme;

  keyboard = config.sylveon.hardware.inputs.keyboard;
  mouse = config.sylveon.hardware.inputs.mouse;
in
{

  options.sylveon.hardware.inputs = {
    keyboard = {
      layout = mkOpt str "de" "What keyboard layout to use";
    };

    mouse = {
      accelProfile = mkOpt (enum [ "flat" "adaptive" ]) "flat" "What accelProfile should be activated";
      accelSpeed = mkOpt float (-0.7) "The mouse speed that should be set";
    };

    touchpad = {
      accelProfile = mkOpt (enum [ "flat" "adaptive" ]) mouse.accelProfile "What accelProfile should be activated";
      accelSpeed = mkOpt float mouse.accelSpeed "The mouse speed that should be set";

      naturalScroll = mkOpt bool true "Whether or not to enable natural scroll";
      disableWhileTyping = mkOpt bool true "Wheter or not to disable the touchpad while typing";
    };
  };

  config = {
    services.xserver.xkb.layout = keyboard.layout;
    console.keyMap = keyboard.layout;
  };
}