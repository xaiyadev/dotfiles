pragma Singleton

import Quickshell
import Quickshell.Networking as QsNet
import QtQuick

import '../data'

Singleton {
    id: root

    readonly property var devices: QsNet.Networking.devices.values
    readonly property var wifiDevice: devices.find(d => d.type === QsNet.DeviceType.Wifi) ?? null
    readonly property var wiredDevice: devices.find(d => d.type === QsNet.DeviceType.Wired && d.connected) ?? null

    readonly property bool wifiEnabled: QsNet.Networking.wifiEnabled
    readonly property var activeWifi: wifiDevice?.networks.values.find(n => n.connected) ?? null

    // connected first, then known networks, then by signal
    readonly property var networks: (wifiDevice?.networks.values ?? []).slice().sort((a, b) =>
        (b.connected - a.connected) || (b.known - a.known) || (b.signalStrength - a.signalStrength))

    readonly property string icon: {
        if (wiredDevice) return Icons.wired;
        if (!wifiEnabled) return Icons.wifiDisabled;
        if (!activeWifi) return Icons.wifiOffline;
        return Icons.wifi(activeWifi.signalStrength);   // signalStrength is 0..1
    }

    function isSecured(network): bool {
        return network.security !== QsNet.WifiSecurityType.Open && network.security !== QsNet.WifiSecurityType.Unknown;
    }

    function setWifiEnabled(enabled: bool): void { QsNet.Networking.wifiEnabled = enabled; }

    // scan for networks only while the network popup is open
    Binding {
        when: root.wifiDevice !== null
        target: root.wifiDevice
        property: "scannerEnabled"
        value: Popups.currentKind === "network"
    }
}
