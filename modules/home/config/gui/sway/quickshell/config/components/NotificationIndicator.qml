import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../services"
import "../data"
import "ui"

// Bell (dot when there are notifications, crossed out in do-not-disturb).
// Popup: do-not-disturb switch, notification history, clear all.
BarModule {
    id: root

    kind: "notifications"
    icon: Notifications.doNotDisturb ? Icons.bellOff : Icons.bell
    badge: Notifications.count > 0 && !Notifications.doNotDisturb
    popupWidth: 360

    PanelHeader {
        icon: Icons.bellOff
        title: "Do not disturb"
        showSwitch: true
        checked: Notifications.doNotDisturb
        onToggled: Notifications.doNotDisturb = !Notifications.doNotDisturb
    }

    StyledText {
        Layout.fillWidth: true
        Layout.topMargin: 10
        Layout.bottomMargin: 10
        visible: Notifications.count === 0
        text: "No notifications"
        color: Theme.overlay0
        horizontalAlignment: Text.AlignHCenter
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(list.implicitHeight, 480)
        visible: Notifications.count > 0
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            id: list
            width: parent.width
            spacing: 6

            Repeater {
                // ScriptModel: only changed entries are added/removed instead of rebuilding all rows
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
