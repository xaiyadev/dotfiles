import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"
import "../data"
import "ui"

// Network: signal icon. Popup, two columns: Wi-Fi (on/off, networks, password for new
// ones) and Tailscale (on/off, tailnet, this device, exit node, devices).
BarModule {
    id: root

    // network that currently shows the password field
    property var passwordTarget: null

    // start without an open password field every time
    Connections {
        target: root.popup
        function onOpenChanged() { root.passwordTarget = null; }
    }

    kind: "network"
    popupWidth: Tailscale.available ? 600 : 300
    icon: Network.icon
    // dot while Tailscale is connected
    badge: Tailscale.running

    RowLayout {
        Layout.fillWidth: true
        spacing: 16

        // ---- Wi-Fi ----
        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignTop
            spacing: 10

            PanelHeader {
                icon: Icons.wifi(1)
                title: "Wi-Fi"
                showSwitch: Network.wifiDevice !== null
                checked: Network.wifiEnabled
                onToggled: Network.setWifiEnabled(!Network.wifiEnabled)
            }

            StyledText {
                visible: Network.wiredDevice !== null
                text: "Ethernet connected"
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize
            }

            ColumnLayout {
                Layout.fillWidth: true
                visible: Network.wifiEnabled
                spacing: 2

                Repeater {
                    // ScriptModel: rows (and a half-typed password) survive scans
                    model: ScriptModel { values: Network.networks.slice(0, 6) }

                    ColumnLayout {
                        id: entry
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 4

                        ListItem {
                            icon: Icons.wifi(entry.modelData.signalStrength)
                            text: entry.modelData.name
                            active: entry.modelData.connected
                            subtext: entry.modelData.stateChanging ? "Connecting…"
                                : entry.modelData.connected ? "Connected"
                                : entry.modelData.known ? "Saved" : ""
                            trailingIcon: Network.isSecured(entry.modelData) ? Icons.lock : ""
                            onClicked: {
                                const n = entry.modelData;
                                if (n.connected) n.disconnect();
                                else if (n.known || !Network.isSecured(n)) n.connect();
                                else root.passwordTarget = root.passwordTarget === n ? null : n;
                            }
                        }

                        // password for a new secured network
                        Rectangle {
                            Layout.fillWidth: true
                            visible: root.passwordTarget === entry.modelData
                            implicitHeight: 30
                            radius: 8
                            color: Theme.surface0

                            TextInput {
                                id: password
                                anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                                verticalAlignment: TextInput.AlignVCenter
                                echoMode: TextInput.Password
                                color: Theme.text
                                font.family: Theme.font
                                font.pixelSize: Theme.smallFontSize + 1
                                clip: true
                                focus: parent.visible

                                onAccepted: {
                                    entry.modelData.connectWithPsk(text);
                                    text = "";
                                    root.passwordTarget = null;
                                }

                                StyledText {
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: password.text === ""
                                    text: "Password, Enter to connect"
                                    color: Theme.overlay0
                                    font.pixelSize: Theme.smallFontSize
                                }
                            }
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            ActionButton {
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom

                icon: "preferences-system-symbolic"
                text: "Network settings"
                onClicked: Quickshell.execDetached(["nm-connection-editor"])
            }


        }

        Separator {
            vertical: true
            visible: Tailscale.available
        }

        // ---- Tailscale ----
        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignTop
            visible: Tailscale.available
            spacing: 10

            PanelHeader {
                icon: Icons.tailscale
                title: "Tailscale"
                showSwitch: true
                checked: Tailscale.running
                onToggled: Tailscale.setRunning(!Tailscale.running)
            }

            StyledText {
                visible: !Tailscale.running
                text: Tailscale.backendState === "Stopped" ? "Disconnected" : Tailscale.backendState
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize
            }

            ColumnLayout {
                Layout.fillWidth: true
                visible: Tailscale.running
                spacing: 2

                InfoRow { label: "Tailnet"; value: Tailscale.tailnet }
                InfoRow { label: "Exit node"; value: Tailscale.exitNode || "none" }

                // devices: click opens the admin console, the copy button copies the IP
                DeviceRow {
                    Layout.topMargin: 4
                    name: Tailscale.hostName + " (this device)"
                    ip: Tailscale.ip
                    os: "linux"
                    detail: Tailscale.ip
                }

                Repeater {
                    model: Tailscale.peers.slice(0, 6)

                    DeviceRow {
                        required property var modelData
                        name: modelData.name
                        ip: modelData.ip
                        os: modelData.os
                        online: modelData.online
                        exitNode: modelData.exitNodeOption
                        detail: modelData.online ? modelData.ip : "offline, " + Tailscale.since(modelData.lastSeen)
                    }
                }
            }

            Item { Layout.fillHeight: true }

            ActionButton {
                Layout.alignment: Qt.AlignRight
                visible: Tailscale.running
                icon: "web-browser-symbolic"
                text: "Admin console"
                onClicked: Tailscale.openInAdmin("")
            }
        }
    }

    // Tailscale device: click opens it in the admin console, the button next to it copies the IP
    component DeviceRow: RowLayout {
        id: device

        property string name
        property string ip
        property string os
        property bool online: true
        property bool exitNode: false
        property string detail

        Layout.fillWidth: true
        spacing: 2

        ListItem {
            Layout.fillWidth: true
            icon: Tailscale.osIcon(device.os)
            text: device.name
            active: device.online
            subtext: device.ip !== "" && Tailscale.copied === device.ip ? "Copied " + device.ip : device.detail
            trailing: device.exitNode ? "exit node" : ""
            onClicked: Tailscale.openInAdmin(device.ip)
        }

        IconButton {
            readonly property bool copied: Tailscale.copied === device.ip
            visible: device.ip !== ""
            icon: copied ? "object-select-symbolic" : "edit-copy-symbolic"
            iconColor: copied ? Theme.accent : hovered ? Theme.text : Theme.subtext0
            onClicked: Tailscale.copy(device.ip)
        }
    }
}
