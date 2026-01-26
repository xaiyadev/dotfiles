# Packages that are not configurable/are not configured will land here
{ pkgs, inputs', osConfig, ... }:
{
  # TODO: generalized home.packages (extra packages) ?
  home.packages = [
    pkgs.gnome-calendar # Calendar app TODO: module for adding all necessary calendars
    pkgs.obsidian # Notes taking app

    pkgs.gamescope # game environment
    pkgs.prismlauncher # Minecraft
    inputs'.aagl.packages.sleepy-launcher # ZZZ launcher

    # Music/Media players
    pkgs.mpv # Music streaming
    inputs'.tidaLuna.packages.default # Music Streaming Service (injected)

    pkgs.teams-for-linux # Teams; Need that for school and work
    #pkgs.ciscoPacketTracer8 # Cisco software that I need for school

    pkgs.devenv
  ];
}
