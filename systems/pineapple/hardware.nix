{ modulesPath, ... }:
{
  imports = # IS NEEDED, TODO: where to move?
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/781e27fd-c41b-479c-a792-231cfaefbdfa";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3A9D-DB5D";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];
}
