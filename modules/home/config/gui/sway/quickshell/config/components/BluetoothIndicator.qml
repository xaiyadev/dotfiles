import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth as QsBluetooth
import "../services"
import "../data"
import "ui"

// Bluetooth: icon + connected device and its battery. Popup: on/off, paired devices.
BarModule {
    id: root

    kind: "bluetooth"
    icon: Bluetooth.icon
    // dot while a device is connected
    badge: Bluetooth.connected.length > 0

    PanelHeader {
        icon: Icons.bluetooth
        title: "Bluetooth"
        showSwitch: Bluetooth.adapter !== null
        checked: Bluetooth.enabled
        onToggled: Bluetooth.setEnabled(!Bluetooth.enabled)
    }

    ColumnLayout {
        Layout.fillWidth: true
        visible: Bluetooth.enabled
        spacing: 2

        Repeater {
            model: ScriptModel { values: Bluetooth.devices }

            ListItem {
                required property var modelData
                icon: (modelData.icon || "bluetooth") + "-symbolic"
                text: modelData.name
                active: modelData.connected
                subtext: modelData.pairing ? "Pairing…"
                    : modelData.state === QsBluetooth.BluetoothDeviceState.Connecting ? "Connecting…"
                    : modelData.connected ? "Connected" : ""
                trailing: modelData.batteryAvailable ? Math.round(modelData.battery * 100) + "%" : ""
                onClicked: Bluetooth.toggleConnection(modelData)
            }
        }

        StyledText {
            visible: Bluetooth.devices.length === 0
            text: "No paired devices"
            color: Theme.subtext0
            font.pixelSize: Theme.smallFontSize
        }
    }

    ActionButton {
        Layout.alignment: Qt.AlignRight
        icon: "preferences-system-symbolic"
        text: "Bluetooth settings"
        onClicked: Quickshell.execDetached(["overskride"])
    }
}
