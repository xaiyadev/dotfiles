# Packages that are not configurable/are not configured will land here
{ pkgs, ... }:
{
  home.packages = [
    pkgs.neovim

    pkgs.enpass

    pkgs.jetbrains.phpstorm # Programming IDE for web
    pkgs.obsidian # Notes taking app TODO: move to own module

    pkgs.tidal-hifi # Music Streaming Service (injected) TODO: add to own module

    pkgs.whatsapp-for-linux

    pkgs.teams-for-linux # Teams; Need that for school and work
  ];
}
