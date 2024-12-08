{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,

    # An instance of `pkgs` with your overlays and packages applied is also available.
    pkgs,

    # You also have access to your flake's inputs.
    inputs,

    # Additional metadata is provided by Snowfall Lib.
    namespace, # The namespace used for your flake, defaulting to "internal" if not set.
    system, # The system architecture for this host (eg. `x86_64-linux`).
    target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
    format, # A normalized name for the system target (eg. `iso`).
    virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
    systems, # An attribute map of your defined hosts.

    # All other arguments come from the system system.
    config,
    ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  environment.systemPackages = with pkgs; [
    jq

    git
    devenv

    inputs.zen-browser.packages."${system}".default

    xivlauncher # Final Fantasy 14; TODO: will be replaced in: https://github.com/BreakingTV/nur-packages
    
    neptune # Temporary solution until switch to v4
  ];

  fonts.packages = with pkgs; [
    font-awesome
    material-design-icons
    nerd-fonts.jetbrains-mono

  ];

  virtualisation.docker.enable = true;
  hardware.sane.enable = true;
  users.users.semiko.extraGroups = [ "scanner" "docker" ];
  users.users.medea.extraGroups = [ "docker" ];

  ${namespace} = {
    desktop.sddm.enable = true;

    common = {
      locale.enable = true;
      pipewire.enable = true;

      grub = {
        enable = true;
        windows.enable = true;
      };

      nix = {
        enable = true;
        lix.enable = true;
      };

      ssh.enable = true;
      zsh.enable = true;

      networking.enable = true;
    };

    programs = {
    	steam.enable = true;
    };
  };

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
