{
  modulesPath,
  ...
}:
{
  # TODO: fix
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4f4e0f4d-30d9-4f5f-9a6c-b2f1eabc2554";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9E0C-CC9D";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };


  fileSystems."/mnt/storage" =
    { device = "/dev/disk/by-uuid/08c38430-8c59-4ceb-acdf-97d6dd715c5c";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2b82c4a9-bb48-4b63-a718-922fa9cbaf5d"; }
    ];
}