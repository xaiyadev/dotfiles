import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../services"
import "../data"
import "ui"

// One notification:
//   [app icon] app name ........ time  x
//   summary                          [image]
//   body
//   [actions]
// Click runs the default action; the x dismisses it.
Rectangle {
    id: root

    required property Notification notification
    readonly property bool hovered: mouse.containsMouse || close.hovered

    readonly property string appIconSource: notification.appIcon !== "" ? Apps.source(notification.appIcon, "") : ""
    readonly property string imageSource: notification.image !== "" ? Apps.source(notification.image, "") : ""

    Layout.fillWidth: true
    implicitHeight: content.implicitHeight + 24
    radius: 10
    color: mouse.containsMouse ? Theme.surface0 : Theme.base
    border {
        width: 1
        color: notification.urgency === NotificationUrgency.Critical ? Theme.red : Theme.surface0
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Notifications.activate(root.notification)
    }

    ColumnLayout {
        id: content
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
        spacing: 6

        // --- header ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            IconImage {
                implicitSize: 16
                visible: root.appIconSource !== ""
                source: root.appIconSource
            }

            Icon {
                visible: root.appIconSource === ""
                icon: "dialog-information-symbolic"
                size: 16
                color: Theme.subtext0
            }

            StyledText {
                Layout.fillWidth: true
                text: root.notification.appName
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize - 1
            }

            StyledText {
                text: Notifications.timeOf(root.notification)
                color: Theme.overlay0
                font.pixelSize: Theme.smallFontSize - 1
            }

            IconButton {
                id: close
                icon: "window-close-symbolic"
                iconSize: 12
                showBackground: false
                iconColor: hovered ? Theme.text : Theme.overlay0
                onClicked: root.notification.dismiss()
            }
        }

        // --- text (+ image) ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 2

                StyledText {
                    Layout.fillWidth: true
                    text: root.notification.summary
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    font.bold: true
                    font.pixelSize: Theme.smallFontSize + 2
                }

                StyledText {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: root.notification.body
                    textFormat: Text.StyledText
                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    color: Theme.subtext0
                    font.pixelSize: Theme.smallFontSize + 1
                }
            }

            ClippingRectangle {
                Layout.alignment: Qt.AlignTop
                visible: root.imageSource !== ""
                implicitWidth: 44
                implicitHeight: 44
                radius: 8
                color: "transparent"

                Image {
                    anchors.fill: parent
                    source: root.imageSource
                    fillMode: Image.PreserveAspectCrop
                    sourceSize { width: 88; height: 88 }
                    asynchronous: true
                }
            }
        }

        // --- actions other than the default (that one is the click) ---
        RowLayout {
            Layout.topMargin: 2
            visible: actions.count > 0
            spacing: 6

            Repeater {
                id: actions
                model: root.notification.actions.filter(a => a.identifier !== "default")

                ActionButton {
                    required property var modelData
                    text: modelData.text
                    onClicked: modelData.invoke()
                }
            }
        }
    }
}
