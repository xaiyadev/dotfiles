{
  # swap out sudo with sudo-rs just like ubunut does
  # <https://discourse.ubuntu.com/t/adopting-sudo-rs-by-default-in-ubuntu-25-10/60583>
  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;

    # only allow members of the wheel group to execute sudo
    execWheelOnly = true;

    # remove lectures
    extraConfig = ''
      Defaults !lecture
      Defaults env_keep += "EDITOR PATH DISPLAY"
    '';
  };
}
