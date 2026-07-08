# TODO: mindlessly coppied from isabel to make my tower work (framework burned.. oughh)
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.sylveon.hardware) gpu;
  inherit (lib.modules) mkIf mkDefault;
in
{
  config = mkIf (gpu == "nvidia") {
    services.xserver.videoDrivers = [ "nvidia" ];

    boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";

      GBM_BACKEND = "nvidia-drm";
      WLR_DRM_DEVICES = mkDefault "/dev/dri/card1";
    };

    sylveon.packages = {
      inherit (pkgs)
        # vulkan
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        # libva
        libva
        libva-utils
        ;
    };

    hardware = {
      nvidia = {
        # use the latest and greatest nvidia drivers
        branch = "bleeding_edge";

        powerManagement = {
          enable = true;
          finegrained = false;
        };

        open = false;
        nvidiaSettings = false;
      };

      graphics = {
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
        extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
      };
    };
  };
}