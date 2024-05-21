{
    users.users.semiko = {
        isNormalUser = true;
        initialPassword = "server";
        description = "Server User";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
}
