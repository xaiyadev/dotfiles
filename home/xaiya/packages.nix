# Packages that are not configurable/are not configured will land here
{ pkgs, inputs, ... }:
{
  home.packages = [
    pkgs.jetbrains.webstorm # Programming IDE for web
    pkgs.obsidian # Notes taking app TODO: move to own module

    pkgs.prismlauncher # Minecraft Launcher
    pkgs.steam # Steam, Games Launcher

    pkgs.tidal-hifi # Music Streaming Service (injected) TODO: add to own module

    pkgs.teams-for-linux # Teams; Need that for school and work
  ];
}