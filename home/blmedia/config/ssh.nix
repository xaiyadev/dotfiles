{ osConfig, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  # Git login used only for work related things
  programs.ssh.matchBlocks."bitbucket.org" =
    (mkIf (builtins.hasAttr "ssh-tangled" osConfig.age.secrets) { # TODO: manage it into: knot.xaiya.dev
      user = "git";
      hostname = "bitbucket.org";
      identityFile = osConfig.age.secrets."ssh-bb".path;
    });
}
