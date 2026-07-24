{
  modulesPath,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/277aad2a-b128-4c54-8351-2c18c94b9f5d";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7DD9-50F7";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # add webdav mount TODO: move?
  age.secrets.davfs-webdav.rekeyFile = "${inputs.self}/secrets/davfs-webdav.age";
  services.davfs2 = {
    enable = true;
    settings.globalSection.use_locks = false;
  };

  # created a symlink t oour secrets file
  systemd.tmpfiles.rules = [
    "L+ /etc/davfs2/secrets - - - - ${config.age.secrets.davfs-webdav.path}"
  ];

  fileSystems."/mnt/webdav/apricot" = {
    device = "https://files.xaiya.dev/";
    fsType = "davfs";

    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "_netdev"
      "user"
      "uid=1002" # xaiya user TODO
    ];
  };
  

  swapDevices = [
    { device = "/dev/disk/by-uuid/6355637c-d51c-4718-9133-ad301068e561"; }
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
