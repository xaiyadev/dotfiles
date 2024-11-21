{
  lib,
  pkgs,
  inputs,

  namespace,
  target,
  format,
  virtual,
  host,

  config,
  osConfig,
  ...
}:
with lib;
with lib.${namespace};
{

  # This configuration will only be enabled when the nixOS modules is enabled
  # This helps with visibility and keeps them in one
  config = mkIf osConfig.${namespace}.desktop.sway {
    ${namespace}.desktop.addons = {
      kanshi = enabled;
    };
  };
}
