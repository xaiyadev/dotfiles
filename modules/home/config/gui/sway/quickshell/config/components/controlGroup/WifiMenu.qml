pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../services"
import "../../data"
import "../ui"

// Wi-Fi network list; secured networks we dont know yet ask for the password inline
SubPopup {
    id: root

    // network whose password field is open
    property var passwordTarget: null

    implicitWidth: 300
    onShownChanged: if (!shown) passwordTarget = null

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

        ColumnLayout {
            id: entry
            required property var modelData
            Layout.fillWidth: true
            spacing: 2

            ListItem {
                icon: Network.wifiIcon(entry.modelData.signalStrength)
                text: entry.modelData.name
                active: entry.modelData.connected
                subtext: entry.modelData.stateChanging ? "Connecting…"
                    : entry.modelData.connected ? "Connected"
                    : entry.modelData.known ? "Saved" : ""
                trailingIcon: Network.isSecured(entry.modelData) ? "lock" : ""
                onClicked: {
                    const n = entry.modelData;
                    if (n.connected) n.disconnect();
                    else if (n.known || !Network.isSecured(n)) n.connect();
                    else root.passwordTarget = root.passwordTarget === n ? null : n;
                }
            }

            Rectangle {
                Layout.fillWidth: true
                visible: root.passwordTarget === entry.modelData
                implicitHeight: 30
                radius: Theme.mediumRadius
                color: Theme.surface0

                TextInput {
                    id: pwd
                    anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: TextInput.Password
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: Theme.mediumFontSize
                    clip: true
                    focus: parent.visible
                    onAccepted: {
                        entry.modelData.connectWithPsk(text);
                        text = "";
                        root.passwordTarget = null;
                    }
                    StyledText {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: pwd.text === ""
                        text: "Password, Enter to connect"
                        color: Theme.overlay0
                        font.pixelSize: Theme.smallFontSize
                    }
                }
            }
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