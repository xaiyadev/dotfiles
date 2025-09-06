# Packages that are not configurable/are not configured will land here
{ pkgs, inputs', ... }:
{
  home.packages = [
    pkgs.obsidian # Notes taking app

    # Gaming packages
    pkgs.steam # Gaming stuff
    pkgs.gamescope # Having games in a specific window with extra configurations

    pkgs.lutris # Game launcher
    pkgs.prismlauncher # Minecraft
    inputs'.aagl.packages.sleepy-launcher # ZZZ launcher

    # Music/Media players
    pkgs.mpv # Music streaming
    inputs'.tidaLuna.packages.default # Music Streaming Service (injected)

    pkgs.wasistlos # Whatsapp for linux

    pkgs.teams-for-linux # Teams; Need that for school and work
    #pkgs.ciscoPacketTracer8 # Cisco software that I need for school
  ];
}
