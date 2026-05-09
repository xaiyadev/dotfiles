{
  config,
  lib,
  inputs,
  self,
  ...
}:
let
  inherit (lib.sources) cleanSource;
  inherit (lib) mkImageMediaOverride;

  hostname = config.networking.hostName or "nixos";

  # The git tree rev or "dirty"
  rev = self.shortRev or "dirty";

  name = "${hostname}-${config.system.nixos.release}-${rev}";
in
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

    ./boot.nix
    ./console.nix
    ./networking.nix
  ];

  config = {
    image = {
      baseName = mkImageMediaOverride name;
      extension = "iso";
    };

    isoImage = {
      volumeID = mkImageMediaOverride name;

      # remove all boot menu labels
      appendToMenuLabel = "";

      # remove "minimal" from the name
      edition = "";

      # TODO: does.. nothing?
      contents = [
        {
          # provide our flake
          source = self;
          target = "/flake";
        }
      ];
    };
  };
}
