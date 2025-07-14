{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/10bae002-72c9-4746-8dc2-4e0fd855b869";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6450-08F2";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  fileSystems."/home" =
  {
    device = "/dev/disk/by-uuid/754c70a8-f4c6-4b82-899a-4a4d0daf7cf1";
    fsType = "ext4";
  };

  swapDevices = [ ];
}
