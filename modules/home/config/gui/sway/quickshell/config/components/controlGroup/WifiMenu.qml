pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components.ui

// Wi-Fi network list, click to (dis)connect
SubPopup {
    id: root

    implicitWidth: 300
    // the full list: 7 rows with a subtitle (44 + 2 spacing), settings button, padding
    reservedHeight: 7 * 46 + 34 + 16

    // only scan while the list is visible; `visible` and not `shown` because stopping the scan drops
    // unsaved networks from the list, and that shouldnt happen during the close animation
    Binding {
        when: root.visible && Network.wifiDevice !== null
        target: Network.wifiDevice
        property: "scannerEnabled"
        value: true
    }

    Placeholder {
        visible: !Network.wifiEnabled
        text: "Wi-Fi is off"
    }

    Repeater {
        // only the first few so the list stays short
        model: ScriptModel { values: Network.wifiEnabled ? Network.networks.slice(0, 7) : [] }

        ListItem {
            required property var modelData
            icon: Network.wifiIcon(modelData.signalStrength)
            text: modelData.name
            active: modelData.connected
            subtext: modelData.stateChanging ? "Connecting…"
                : modelData.connected ? "Connected"
                : modelData.known ? "Saved" : ""
            trailingIcon: Network.isSecured(modelData) ? "lock" : ""
            onClicked: Network.toggleConnection(modelData)
        }
    }

    ActionButton {
        Layout.alignment: Qt.AlignRight
        Layout.topMargin: 4
        icon: "settings"
        text: "Network settings"
        onClicked: Quickshell.execDetached(["nm-connection-editor"])
    }
}
