{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.nvidia;
in {

  options.${namespace}.hardware.nvidia = with types; {
    enable = mkBoolOpt false "Wheter or not to install all necessary fonts";
  };

  config = mkIf cfg.enable {

  /* Configure Nvidia Drivers  */
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ vulkan-validation-layers ];
    };

    nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;

        modesetting.enable = true;
        powerManagement.enable = true;

        nvidiaPersistenced = true;

        open = true;
        nvidiaSettings = true;
      };
  };
  };
}
