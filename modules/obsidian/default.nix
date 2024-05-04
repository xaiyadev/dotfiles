{ pkgs, ...}: {

    # Install Obsidian
    home.packages = with pkgs; [
        obsidian
    ];

    # Install Vault
    home.file."Documents/Obsidian/Vault/" = {
        source = fetchGit {
           url = "https://git.semiko.dev/Synchroniser/obsidian-sync";
        };
    };

}