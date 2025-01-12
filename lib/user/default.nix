{ lib, ... }:
with lib;
{
  mkUserConfiguration =
    password: extraGroups:
    {
      extraGroups = extraGroups;
      useDefaultShell = true;
      hashedPasswordFile = password;
    };
}
