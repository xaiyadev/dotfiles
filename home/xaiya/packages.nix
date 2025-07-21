# Packages that are not configurable/are not configured will land here
{ pkgs, inputs', ... }:
{
  home.packages = [
    pkgs.neovim
    # https://github.com/NixOS/nixpkgs/issues/426815#issuecomment-3094569105
    (pkgs.jetbrains.webstorm.override { jdk = pkgs.openjdk21; })
    pkgs.obsidian # Notes taking app

    pkgs.prismlauncher # Minecraft Launcher
    pkgs.steam # Steam, Games Launcher

    inputs'.tidaLuna.packages.default # Music Streaming Service (injected)

    pkgs.wasistlos # Whatsapp for linux

    pkgs.teams-for-linux # Teams; Need that for school and work
    #pkgs.ciscoPacketTracer8 # Cisco software that I need for school
  ];
}
