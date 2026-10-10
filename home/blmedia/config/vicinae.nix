{ config, pkgs, ... }:
let
  mkRayExt = name: sha256: npmDepsHash: (config.lib.vicinae.mkRayCastExtension {
    inherit name sha256 npmDepsHash;
    rev = "b94f62edfdf9afe433c46aa2de870b48feae6520";
  });

  # Can be removed once bookstack updates @raycast/api.
  # https://github.com/nix-community/home-manager/issues/8262
  ray-1_72_1 = pkgs.fetchurl {
    url = "https://cli.raycast.com/1.72.1/linux/ray";
    hash = "sha256-efrOw27pbuy37zxtKkwKdwoLrIMh5GqWR2eRtrr59kk=";
  };

in
{
  programs.vicinae.extensions = [
    (mkRayExt "bitbucket" "sha256-rXKS2OAnL1X4M0vAksnd+I9S0vGD1HHssxxQdMs9GLI=" "sha256-eH4q+6mohBDdC4nQrbVYmSy39mtj8991eJQKCwTr4hM=")

    (
      (mkRayExt "bookstack" "sha256-TsJx+iR1QnRAmAALAuE7Mxt7umRaZIeM3Gbgeg8Eq/4=" "sha256-OdkA4YMNx3GT69TycZFgJmy3nZibzJ6VpE6dqPIdtdA=")
      .overrideAttrs
      (old: {
        # fix just for this plugin because its behind
        preBuild = (old.preBuild or "") + ''
          install -Dm755 ${ray-1_72_1} node_modules/@raycast/api/bin/linux/ray
        '';
      })
    )
  ];
}
