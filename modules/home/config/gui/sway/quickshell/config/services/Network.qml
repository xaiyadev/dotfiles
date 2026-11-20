pragma Singleton

import Quickshell
import Quickshell.Networking as QsNet
import QtQuick

Singleton {
    readonly property var devices: QsNet.Networking.devices.values
    readonly property var wifiDevice: devices.find(d => d.type === QsNet.DeviceType.Wifi) ?? null
    readonly property var wiredDevice: devices.find(d => d.type === QsNet.DeviceType.Wired && d.connected) ?? null

    readonly property bool wifiEnabled: QsNet.Networking.wifiEnabled
    readonly property var activeWifi: wifiDevice?.networks.values.find(n => n.connected) ?? null

    // get the visible networks and order them
    readonly property var networks: (wifiDevice?.networks.values ?? []).filter(n => n.name !== "").sort((a, b) =>
        (b.connected - a.connected) || (b.known - a.known)
        || (Math.round(b.signalStrength * 4) - Math.round(a.signalStrength * 4))
        || a.name.localeCompare(b.name))

    readonly property string icon: {
        if (wiredDevice) return "lan";
        if (!wifiEnabled) return "signal_wifi_off";
        if (!activeWifi) return "signal_wifi_0_bar";
        return wifiIcon(activeWifi.signalStrength);
    }

    function wifiIcon(strength: real): string {
        return strength > 0.75 ? "signal_wifi_4_bar"
             : strength > 0.5  ? "network_wifi_3_bar"
             : strength > 0.25 ? "network_wifi_2_bar"
             : "network_wifi_1_bar";
    }

    // check if password is needed
    function isSecured(network): bool {
        return network.security !== QsNet.WifiSecurityType.Open && network.security !== QsNet.WifiSecurityType.Unknown;
    }

    function setWifiEnabled(enabled: bool): void { QsNet.Networking.wifiEnabled = enabled; }

    // connect and disconnect from connections
    // if password needed send prompt  TODO: implement prompt
    function toggleConnection(network): void {
        if (network.connected) network.disconnect();
        else if (network.known || !isSecured(network)) network.connect();
        else Quickshell.execDetached(["notify-send", "-a", "Quickshell", "Wi-Fi", "WIFI logins not implemented yet"]);
    }
}
