import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../services"
import "../data"
import "ui"

Item {
    id: root

    property string systemName: "System"

    Process {
        running: true
        command: ["hostname"]
        stdout: StdioCollector {
            onStreamFinished: root.systemName = this.text.trim() || "System"
        }
    }

    // ---- bar ----
    implicitWidth: barLayout.implicitWidth
    implicitHeight: 20

    RowLayout {
        id: barLayout
        anchors.centerIn: parent
        spacing: 8

        // notification bell
        Item {
            implicitWidth: Theme.iconSize
            implicitHeight: Theme.iconSize

            Icon {
                anchors.fill: parent
                icon: Notifications.doNotDisturb ? Icons.bellOff : Icons.bell
            }

            Rectangle {
                visible: Notifications.count > 0 && !Notifications.doNotDisturb
                anchors { right: parent.right; bottom: parent.bottom; rightMargin: -3; bottomMargin: -2 }
                width: 8; height: 8; radius: 4
                color: Theme.accent
                border { width: 2; color: Theme.base }
            }
        }

        // battery
        Item {
            visible: Power.present
            implicitWidth: Theme.iconSize
            implicitHeight: Theme.iconSize
            Layout.leftMargin: 6
            BatteryIcon {
                anchors.fill: parent
                level: Power.percent / 100
                charging: Power.charging && !GameMode.active
                color: Power.levelColor
            }
        }

        StyledText {
            visible: Power.present
            text: Power.percent + "%"
            color: Power.levelColor
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: popup.toggle()
        onContainsMouseChanged: {
            if (containsMouse && Popups.current !== null && !popup.open) popup.toggle()
        }
    }

    BarPopup {
        id: popup
        trigger: root
        triggerHovered: mouse.containsMouse
        kind: "system"
        cardWidth: 360

        // ---- header: hostname + battery ----
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Icon { icon: Icons.laptop; size: 16 }

            StyledText {
                Layout.fillWidth: true
                text: root.systemName
                font.bold: true
            }

            RowLayout {
                visible: Power.present
                spacing: 4

                BatteryIcon {
                    implicitWidth: 16
                    implicitHeight: 16
                    level: Power.percent / 100
                    charging: Power.charging
                    color: Power.levelColor
                }

                StyledText {
                    text: Power.percent + "%"
                    color: Power.levelColor
                    font.pixelSize: Theme.smallFontSize
                }
            }
        }

        Separator { }

        // ---- DND + keep-awake ----
        PanelHeader {
            icon: Icons.bellOff
            title: "Do not disturb"
            showSwitch: true
            checked: Notifications.doNotDisturb
            onToggled: Notifications.doNotDisturb = !Notifications.doNotDisturb
        }

        PanelHeader {
            icon: Icons.eye
            title: "Keep awake"
            showSwitch: true
            checked: IdleInhibit.enabled
            onToggled: IdleInhibit.toggle()
        }

        Separator { }

        // ---- notifications ----
        StyledText {
            Layout.fillWidth: true
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            visible: Notifications.count === 0
            text: "No notifications"
            color: Theme.overlay0
            horizontalAlignment: Text.AlignHCenter
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(notifList.implicitHeight, 280)
            visible: Notifications.count > 0
            contentWidth: availableWidth
            clip: true

            ColumnLayout {
                id: notifList
                width: parent.width
                spacing: 6

                Repeater {
                    model: ScriptModel { values: Notifications.history }
                    NotificationCard {
                        required property var modelData
                        notification: modelData
                    }
                }
            }
        }

        ActionButton {
            Layout.alignment: Qt.AlignRight
            visible: Notifications.count > 0
            icon: "edit-clear-all-symbolic"
            text: "Clear all"
            onClicked: Notifications.clearAll()
        }
    }
}
