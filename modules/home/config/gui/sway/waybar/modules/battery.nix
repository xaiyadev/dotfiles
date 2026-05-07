{
  programs.waybar.settings.mainBar = {
    # The Battery status will be shown
    "battery" = {
      interval = 10;
      full-at = 80; # Changed in BIOS for better capacity

      tooltip-format = "Watt usage: {power} \nCapacity: {capacity}% /time remain: {time} \nBattery cycles: {cycles}";

      states = {
        warning = 30;
        critical = 20;
      };

      format = "{icon} {capacity}%";
      format-charging = "( {icon}) {capacity}%";
      format-full = "󰚥";

      format-icons = [
        "󱟩"
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰁹"
      ];
    };
  };
}
