{ pkgs, ...}: {
    # This module is completly over the system, that way every user can acess that folder!

    systemd.services."obsidianVaultInstall" = {
        enable = true;
        path = with pkgs; [
            git
        ];

        description = "Install my Obsidian Vault, on the System";
        script = ''
                if [ ! -d "/srv/shared/obsidian/obsidian-sync/" ]; then
                    mkdir -p "/srv/shared/obsidian/"
                    cd /srv/shared/obsidian/

                    git clone https://git.semiko.dev/Synchroniser/obsidian-sync
                    git pull
                    # fix HEAD_FETCH no permission when new folder
                    chmod -R a+rw /srv/shared/
                else
                    cd /srv/shared/obsidian/obsidian-sync/
                    git fetch https://git.semiko.dev/Synchroniser/obsidian-sync
                fi
        '';

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];


    };

}