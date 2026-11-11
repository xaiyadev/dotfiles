pragma Singleton

import Quickshell
import QtQuick

// The bar's own icon set (assets/icons): 16px grid, 2px round strokes, filled core shapes,
// levels shown with faint parts (like GNOME). Recoloured by ui/Icon.
Singleton {
    function file(name: string): string { return Qt.resolvedUrl("../assets/icons/" + name + ".svg"); }

    // audio
    readonly property string music: file("music")
    function volume(level: real, muted: bool): string {
        if (muted || level <= 0) return file("volume-muted");
        return file(level > 0.66 ? "volume-high" : level > 0.33 ? "volume-medium" : "volume-low");
    }

    // network (signal strength 0..1)
    readonly property string wired: file("wired")
    readonly property string wifiOffline: file("wifi-offline")
    readonly property string wifiDisabled: file("wifi-disabled")
    function wifi(strength: real): string {
        return file(strength > 0.75 ? "wifi-excellent" : strength > 0.5 ? "wifi-good" : strength > 0.25 ? "wifi-ok" : "wifi-weak");
    }
    readonly property string tailscale: file("tailscale")

    readonly property string bluetooth: file("bluetooth")
    readonly property string bluetoothOff: file("bluetooth-off")

    // display / laptop
    function brightness(level: real): string {
        return file(level < 0.34 ? "brightness-low" : level < 0.67 ? "brightness-medium" : "brightness-high");
    }
    readonly property string laptop: file("laptop")
    readonly property string monitor: file("monitor")
    readonly property string phone: file("phone")
    readonly property string lock: file("lock")

    // session / notifications / clock
    readonly property string power: file("power")
    readonly property string focus: file("focus")
    readonly property string eye: file("eye")
    readonly property string bell: file("bell")
    readonly property string bellOff: file("bell-off")
    readonly property string clock: file("clock")
}
