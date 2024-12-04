{
  lib,
  pkgs,
  inputs,

  namespace,
  target,
  format,
  virtual,
  host,

  osConfig,
  config,
  ...
}:
with lib;
with lib.${namespace};
{
  # This configuration will only be enabled when the nixOS modules is enabled
  # This helps with visibility and keeps them in one
  config = mkIf osConfig.${namespace}.security.yubikey.enable {
    # Here will be the U2F key stored, after creating my system with its new users
  };
}