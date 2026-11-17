pragma Singleton

import Quickshell
import QtQuick

// Adwaita symbolic icon names (set via //@ pragma IconTheme Adwaita in shell.qml).
Singleton {
    // audio
    readonly property string music: "audio-x-generic-symbolic"
    function volume(level: real, muted: bool): string {
        if (muted || level <= 0) return "audio-volume-muted-symbolic";
        return level > 0.66 ? "audio-volume-high-symbolic" : level > 0.33 ? "audio-volume-medium-symbolic" : "audio-volume-low-symbolic";
    }

    // network
    readonly property string wired: "network-wired-symbolic"
    readonly property string wifiOffline: "network-wireless-offline-symbolic"
    readonly property string wifiDisabled: "network-wireless-disabled-symbolic"
    function wifi(strength: real): string {
        return strength > 0.75 ? "network-wireless-signal-excellent-symbolic"
             : strength > 0.5  ? "network-wireless-signal-good-symbolic"
             : strength > 0.25 ? "network-wireless-signal-ok-symbolic"
             : "network-wireless-signal-weak-symbolic";
    }
    readonly property string tailscale: "network-vpn-symbolic"
    readonly property string bluetooth: "bluetooth-active-symbolic"
    readonly property string bluetoothOff: "bluetooth-disabled-symbolic"

    // display / laptop
    function brightness(level: real): string { return "display-brightness-symbolic"; }
    readonly property string laptop: "computer-symbolic"
    readonly property string phone: "phone-symbolic"
    readonly property string lock: "system-lock-screen-symbolic"

    // notifications / session / clock
    readonly property string eye: "view-reveal-symbolic"
    readonly property string bell: "preferences-system-notifications-symbolic"
    readonly property string bellOff: "notifications-disabled-symbolic"
    readonly property string clock: "preferences-system-time-symbolic"
}
