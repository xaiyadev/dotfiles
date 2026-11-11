import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"
import "../data"
import "ui"

// Session hub: power icon (dot while keep-awake is on).
// Popup: focus mode (= game mode, services/GameMode.qml) and keep-awake switches, lock / hibernate / reboot / power off.
// Everything but lock needs a second click to confirm.
BarModule {
    id: root

    // action waiting for its confirmation click
    property string armed: ""

    kind: "session"
    icon: Icons.power
    // dot while keep-awake or game mode is on
    badge: IdleInhibit.enabled || GameMode.active
    popupWidth: 280

    function run(action): void {
        if (action.confirm && armed !== action.id) {
            armed = action.id;
            disarm.restart();
            return;
        }
        armed = "";
        popup.close();
        Quickshell.execDetached(action.command);
    }

    Timer {
        id: disarm
        interval: 3000
        onTriggered: root.armed = ""
    }

    Connections {
        target: root.popup
        function onOpenChanged() { root.armed = ""; }
    }

    // toggles
    PanelHeader {
        icon: Icons.focus
        title: "Focus mode"
        showSwitch: true
        checked: GameMode.active
        onToggled: GameMode.toggle()
    }

    PanelHeader {
        icon: Icons.eye
        title: "Keep awake"
        showSwitch: true
        checked: IdleInhibit.enabled
        onToggled: IdleInhibit.toggle()
    }

    // power actions
    Separator { }

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: 6
        rowSpacing: 6

        Repeater {
            model: [
                { id: "lock", label: "Lock", icon: "system-lock-screen-symbolic", command: ["swaylock"], confirm: false },
                { id: "hibernate", label: "Hibernate", icon: "weather-clear-night-symbolic", command: ["systemctl", "hibernate"], confirm: true },
                { id: "reboot", label: "Reboot", icon: "system-reboot-symbolic", command: ["systemctl", "reboot"], confirm: true },
                { id: "poweroff", label: "Power off", icon: "system-shutdown-symbolic", command: ["systemctl", "poweroff"], confirm: true }
            ]

            Rectangle {
                id: button
                required property var modelData
                readonly property bool isArmed: root.armed === modelData.id

                Layout.fillWidth: true
                implicitHeight: 40
                radius: 8
                color: isArmed ? Theme.red : mouse.containsMouse ? Theme.surface1 : Theme.surface0

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Icon {
                        icon: button.modelData.icon
                        size: 16
                        color: button.isArmed ? Theme.base : Theme.text
                    }

                    StyledText {
                        text: button.isArmed ? "Confirm?" : button.modelData.label
                        color: button.isArmed ? Theme.base : Theme.text
                        font.pixelSize: Theme.smallFontSize + 1
                        font.bold: button.isArmed
                    }
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.run(button.modelData)
                }
            }
        }
    }
}
