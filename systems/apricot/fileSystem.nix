{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5c818ed2-2037-4be6-a2de-6cba2eba6972";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7C42-86BD";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/mnt/raid" = {
    device = "/dev/md127";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/2637159d-5d75-4082-bec6-86d709516478"; } ];
}
