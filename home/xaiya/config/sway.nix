{ lib, inputs', ... }:
let 
  inherit (lib) getExe;
in
{
  # ctrlem startup configuration
  wayland.windowManager.sway.config.startup = [
    { command = getExe inputs'.xaipkgs.packages.ctrlem; }
  ];
}
