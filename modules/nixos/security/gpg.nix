_: {
  # My gpg key is stored on my yubikey

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableBrowserSocket = true;
  };
}
