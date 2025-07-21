# Packages that are not configurable/are not configured will land here
{ pkgs, inputs', ... }:
{
  home.packages = [
    pkgs.neovim

    pkgs.enpass

    # https://github.com/NixOS/nixpkgs/issues/426815#issuecomment-3094569105
    (pkgs.jetbrains.phpstorm.override { jdk = pkgs.openjdk21; })
    pkgs.obsidian # Notes taking app

    inputs'.tidaLuna.packages.default # Music Streaming Service (injected)

    pkgs.wasistlos # Whatsapp for linux

    pkgs.teams-for-linux # Teams; Need that for school and work
  ];
}
