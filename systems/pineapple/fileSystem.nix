{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ce3212c1-5170-48bf-91cd-73c07aa49f83";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B4BE-0C8C";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/303ddaaa-7ee6-4ef6-bd4f-88fd25071899"; }
  ];
}
