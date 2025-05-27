# Packages that are not configurable/are not configured will land here
{ pkgs, inputs', ... }:
{
  home.packages = [
    pkgs.neovim
    pkgs.jetbrains.webstorm # Programming IDE for web
    pkgs.obsidian # Notes taking app

    pkgs.prismlauncher # Minecraft Launcher
    pkgs.steam # Steam, Games Launcher

    inputs'.tidaLuna.packages.default # Music Streaming Service (injected)

    pkgs.whatsapp-for-linux

    pkgs.teams-for-linux # Teams; Need that for school and work
    #pkgs.ciscoPacketTracer8 # Cisco software that I need for school
  ];
}
