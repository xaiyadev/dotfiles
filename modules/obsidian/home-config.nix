{ pkgs, ...}: {
    # TODO: fix file permission to add more vaults (who would use more vaults???)
    home.file.".config/obsidian/obsidian.json".text = ''
        {"vaults":{"0443f0f54e184929":{"path":"/srv/shared/obsidian/obsidian-sync","ts":1715015472356,"open":true}}}
    '';

}