pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../services"
import "../ui"

// paired bluetooth devices, click to (dis)connect
SubPopup {
    implicitWidth: 260

    Placeholder {
        visible: !Bluetooth.enabled || Bluetooth.devices.length === 0
        text: Bluetooth.enabled ? "No paired devices" : "Bluetooth is off"
    }

    Repeater {
        model: ScriptModel { values: Bluetooth.enabled ? Bluetooth.devices : [] }
        ListItem {
            required property var modelData
            icon: Bluetooth.deviceIcon(modelData)
            text: modelData.name
            active: modelData.connected
            subtext: modelData.connected ? "Connected" : "Paired"
            onClicked: Bluetooth.toggleConnection(modelData)
        }
    }

    ActionButton {
        Layout.alignment: Qt.AlignRight
        Layout.topMargin: 4
        icon: "settings"
        text: "Bluetooth settings"
        onClicked: Quickshell.execDetached(["overskride"])
    }
}