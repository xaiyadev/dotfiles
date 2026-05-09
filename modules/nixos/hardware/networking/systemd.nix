{
  # systemd DNS resolver daemon
  services.resolved.enable = true;

  systemd = {
    # allow for the system to boot without waiting for the network interfaces are online
    network.wait-online.enable = false;

    services = {
      # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
      NetworkManager-wait-online.enable = false;

      systemd-networkd.stopIfChanged = false;
      systemd-resolved.stopIfChanged = false;
    };
  };
}
