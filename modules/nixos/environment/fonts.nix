{ pkgs, ... }:
{
  fonts = {
    packages = [
      # Add the Jetbrains mono font
      pkgs.jetbrains-mono
      pkgs.nerd-fonts.jetbrains-mono

      # extra fonts to support specific glyphs and icons
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji-blob-bin
    ];

    # save up some storage
    fontDir.decompressFonts = true;
  };
}
