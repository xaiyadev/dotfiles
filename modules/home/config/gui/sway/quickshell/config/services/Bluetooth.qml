pragma Singleton

import Quickshell
import Quickshell.Bluetooth as QsBluetooth
import QtQuick

Singleton {
    readonly property var adapter: QsBluetooth.Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false

    // paired devices, connected ones first
    readonly property var devices: (adapter?.devices.values ?? [])
        .filter(d => d.paired || d.connected)
        .sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
    readonly property var connected: devices.filter(d => d.connected)

    // bluez gives freedesktop icon names, these are the material symbols for the common ones
    readonly property var deviceIcons: ({
        "audio-headset": "headset_mic",
        "audio-headphones": "headphones",
        "audio-card": "speaker",
        "input-mouse": "mouse",
        "input-keyboard": "keyboard",
        "input-gaming": "sports_esports",
        "phone": "smartphone",
        "computer": "computer"
    })

    function deviceIcon(device): string { return deviceIcons[device?.icon] ?? "bluetooth"; }

    function setEnabled(on: bool): void { if (adapter) adapter.enabled = on; }

    function toggleConnection(device): void {
        if (device.connected) device.disconnect();
        else device.connect();
    }
}
