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
          fanSpeedUpdateFrequency = 10;
          movingAverageInterval = 60;
          speedCurve = [
            { temp = 0;  speed = 22;  }
            { temp = 82; speed = 22;  }   # until ~82 no audibale fans
            { temp = 86; speed = 28;  }
            { temp = 89; speed = 60;  }
            { temp = 91; speed = 100; }   # if reaching over 91, cooldown the laptop
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
