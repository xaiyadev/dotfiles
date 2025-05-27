# Packages that are not configurable/are not configured will land here
{ pkgs, inputs', ... }:
{
  home.packages = [
    pkgs.neovim

    pkgs.enpass

    pkgs.jetbrains.phpstorm # Programming IDE for web
    pkgs.obsidian # Notes taking app

    inputs'.tidaLuna.packages.default # Music Streaming Service (injected)

    pkgs.whatsapp-for-linux

    pkgs.teams-for-linux # Teams; Need that for school and work
  ];
}
