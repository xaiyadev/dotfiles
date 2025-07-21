{ pkgs, ... }:
{
  fonts.packages = [
    # Jetbrains Mono
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
