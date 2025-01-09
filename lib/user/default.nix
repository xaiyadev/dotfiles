{ lib, ... }:
with lib;
{
  mkUserConfiguration =
    password: extraGroups:
    {
      extraGroups = extraGroups;
      useDefaultShell = true;
      initialPassword = password; # TODO: Change to hashed password
    };
}
