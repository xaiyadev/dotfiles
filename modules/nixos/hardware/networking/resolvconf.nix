{ # TODO: fix dns request stuff ++ nameserver bug
  networking.resolvconf = {
    enable = true;
    dnsSingleRequest = true; # Fixes speed for IPv6
  };
}