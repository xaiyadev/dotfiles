{ lib, ... }:
with lib;
{
  mkUserConfiguration =
    password: extraGroups:
    {
      extraGroups = [ "docker" ] ++ extraGroups;
      useDefaultShell = true;
      initialPassword = password; # TODO: Change to hashed password
    };
}