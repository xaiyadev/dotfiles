{ pkgs, ...}: {

  # Create
  systemd.user.services.obsidianSync = {
    description = "Sync Obsidian Vault";
    script = "${./clone-vault.sh}";
    wantedBy = [ "multi-user.target" ];
    environment = {
      HOME = config.home.homeDirectory;
    };
  };
}