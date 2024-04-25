{ config, pkgs, ... }:
{
    users.users.workaholic = {
        isNormalUser = true;
        initialPassword = "semiko";
        description = "Workaholic Deluxe";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
}
