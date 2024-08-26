{ config, pkgs, ... }:
{
    users.users.medea = {
        isNormalUser = true;
	    initialPassword = "semiko";
        description = "Medea Oksana";
        extraGroups = [ "networkmanager" "wheel" ];
    };
}