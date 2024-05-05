{ pkgs, ...}: {
    # This module is completly over the system, that way every user can acess that folder!


    # Install Obsidian
    environment.systemPackages = with pkgs; [
        obsidian
    ];

    system.activationScripts.sripts.text = ''
        if [ ! -d "/srv/shared/obsidian/danil-vault/" ]; then
            mkdir -p "/srv/shared/obsidian/danil-vault"
        fi

        
        git fetch https://git.semiko.dev/Synchroniser/obsidian-sync /srv/shared/obsidian/danil-vault/
        chmod ugo+rwx /srv/shared/obsidian/danil-vault/
    '';

}