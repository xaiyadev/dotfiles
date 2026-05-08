{ pkgs, ... }: {
  system = {
    disableInstallerTools = true;

    tools = {
      nixos-enter.enable = true;
      nixos-install.enable = true;
      nixos-generate-config.enable = true;
    };
  };

  programs.git.package = pkgs.gitMinimal;


}