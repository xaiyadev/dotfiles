pragma Singleton

import Quickshell
import Quickshell.Bluetooth as QsBluetooth
import QtQuick

import '../data'

Singleton {
    id: root

    readonly property var adapter: QsBluetooth.Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false

    // paired devices, connected ones first
    readonly property var devices: (adapter?.devices.values ?? [])
        .filter(d => d.paired || d.connected)
        .sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
    readonly property var connected: devices.filter(d => d.connected)

    // connected devices are shown with the badge dot, see BluetoothIndicator
    readonly property string icon: enabled ? Icons.bluetooth : Icons.bluetoothOff

    function setEnabled(on: bool): void { if (adapter) adapter.enabled = on; }

    function toggleConnection(device): void {
        if (device.connected) device.disconnect();
        else device.connect();
    }
}
