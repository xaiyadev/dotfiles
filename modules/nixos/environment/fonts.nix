_:
{
  fonts = {
    # font managed through home-manager
    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
    };

    # save up some storage
    fontDir.decompressFonts = true;
  };
}
