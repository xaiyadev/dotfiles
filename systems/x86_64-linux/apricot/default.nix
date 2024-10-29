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
    vim
    wget
  ];

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };
  users.users.semiko.extraGroups = [ "dialout" "docker" ];

  ${namespace} = {
    common = {
      locale.enable = true;

      grub.enable = true;
      networking.enable = true;

      nix = {
        enable = true;
        lix.enable = true;
      };

      ssh.enable = true;
      zsh.enable = true;

    };

    # TODO: add services for server
    services = {
      nginx = {
        enable = true;
        acme.enable = true;
      };

      homepage.enable = true;

      firefly.enable = true;
      vaultwarden.enable = true;
      youtrack.enable = true;

      minecraft = {
        enable = true;
        survival.enable = true;
      };
    };
  };

  networking.defaultGateway6 = { address = "fe80::1"; interface = "eno1"; };

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
