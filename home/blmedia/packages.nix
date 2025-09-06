# Packages that are not configurable/are not configured will land here
{ pkgs, inputs', ... }:
{
  home.packages = [
    pkgs.enpass

    pkgs.jetbrains.phpstorm # Mainly using neovim, but for some work stuff still needed
    pkgs.obsidian # Notes taking app

    pkgs.mpv # Music streaming
    inputs'.tidaLuna.packages.default # Music Streaming Service (injected)

    pkgs.wasistlos # Whatsapp for linux

    pkgs.teams-for-linux # Teams; Need that for school and work
  ];
}
