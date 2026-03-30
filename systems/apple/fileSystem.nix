{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/bd81acdf-e2c7-41bb-92e1-ddcdd46e2da9";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6023-7222";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/358f4ce3-9e14-4cf8-ab79-435ebb109db6"; }
    ];
}