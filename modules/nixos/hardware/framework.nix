{ lib, config, ... }:
let
  inherit (lib) mkIf mkAfter;

  prof = config.sylveon.profiles;
in
{
  # framework is currently my only laptop, so setting this as a laptop setting
  config = mkIf prof.laptop.enable {
    # setup fan control for framework devices
    hardware.fw-fanctrl = {
      enable = true;

      config = {
        defaultStrategy = "almost-silent";

        strategies.almost-silent = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 60;
          speedCurve = [
            { temp = 0;   speed = 22;  }
            { temp = 82;  speed = 22;  }   # programming / normal work: inaudible
            { temp = 86;  speed = 30;  }
            { temp = 90;  speed = 40;  }
            { temp = 94;  speed = 55;  }
            { temp = 97;  speed = 75;  }
            { temp = 100; speed = 100; }   # Tctl limit, APU throttles itself here
          ];
        };
      };
    };

    # Prevent wakeup from keyboard touch if lid is close,
    # TODO: fix wrong configuration?
    services.udev.extraRules = mkAfter ''
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    '';
  };

}
