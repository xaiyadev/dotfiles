pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../../services"
import "../../data"
import ".."
import "../ui"

// notification history, grouped by age, with "clear all"
ColumnLayout {
    spacing: 8

    RowLayout {
        Layout.fillWidth: true
        Layout.bottomMargin: 4

        Icon { icon: "notifications"; size: Theme.smallIconSize }

        StyledText {
            Layout.fillWidth: true
            text: "Notifications"
            font.bold: true
        }

        IconButton {
            visible: Notifications.count > 0
            icon: "clear_all"
            showBackground: false
            onClicked: Notifications.clearAll()
        }
    }

    Separator { color: Theme.surface1 }

    Placeholder {
        visible: Notifications.count === 0
        text: "No notifications"
        font.pixelSize: Theme.fontSize
    }

    ScrollView {
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(notifList.implicitHeight, 240)
        visible: Notifications.count > 0
        contentWidth: availableWidth
        clip: true
        focusPolicy: Qt.NoFocus

        ColumnLayout {
            id: notifList
            width: parent.width
            spacing: 8

            Repeater {
                model: ScriptModel { id: notifModel; values: [...Notifications.history] }

                // first card of each age group gets a divider with the group name, see Notifications.ageGroup
                // the previous one comes from the model and not from the history, that one already
                // changed while the delegates still have their old index
                ColumnLayout {
                    id: entry
                    required property var modelData
                    required property int index
                    readonly property string group: Notifications.ageGroup(modelData)
                    readonly property bool firstOfGroup: index === 0
                        || Notifications.ageGroup(notifModel.values[index - 1]) !== group

                    Layout.fillWidth: true
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: entry.index === 0 ? 0 : 4
                        visible: entry.firstOfGroup
                        spacing: 8

                        StyledText {
                            text: entry.group
                            color: Theme.overlay0
                            font.pixelSize: Theme.tinyFontSize
                            font.bold: true
                        }

                        Separator { }
                    }

                    NotificationCard { notification: entry.modelData }
                }
            }
        }
    }
}