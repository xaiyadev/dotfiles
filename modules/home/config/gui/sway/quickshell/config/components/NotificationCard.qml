pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.services
import qs.data
import qs.components.ui

// one notification, used for the toasts and in the history; leave() plays the out animation first
Rectangle {
    id: root

    required property Notification notification
    property bool isToast: false
    readonly property bool hovered: hover.hovered

    // a toast got clicked away; only hides the toast, the notification stays in the history
    signal hidden()

    // needed for the fade animation
    property real collapse: 1
    property bool leaving: false

    function leave(done): void {
        if (leaving) return;
        leaving = true;
        leaveAnim.done = done;
        leaveAnim.start();
    }

    readonly property string appIconSource: AppIcons.source(notification.appIcon)
    readonly property string imageSource: AppIcons.source(notification.image)
    readonly property var defaultAction: notification.actions.find(a => a.identifier === "default") ?? null
    readonly property var otherActions: notification.actions.filter(a => a.identifier !== "default")

    Layout.fillWidth: true
    implicitHeight: (content.implicitHeight + 24) * collapse
    clip: true
    radius: 10
    color: hovered ? Theme.surface0 : Theme.base
    border {
        width: 1
        color: notification.urgency === NotificationUrgency.Critical ? Theme.red : Theme.surface0
    }

    transform: Translate { id: slide }

    SequentialAnimation {
        id: leaveAnim
        property var done: null

        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: Theme.mediumAnimation; easing.type: Easing.OutCubic }
            NumberAnimation { target: slide; property: "x"; to: root.isToast ? 40 : -40; duration: Theme.mediumAnimation; easing.type: Easing.OutCubic }
        }
        NumberAnimation { target: root; property: "collapse"; to: 0; duration: Theme.fastAnimation; easing.type: Easing.InOutCubic }
        ScriptAction { script: leaveAnim.done?.() }
    }

    HoverHandler { id: hover }

    ClickArea {
        enabled: !root.leaving
        onClicked: root.leave(() => root.isToast ? root.hidden() : root.notification?.dismiss())
    }

    RowLayout {
        id: content
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
        spacing: 12

        // app icon
        Item {
            Layout.alignment: Qt.AlignTop
            implicitWidth: 36
            implicitHeight: 36

            IconImage {
                anchors.fill: parent
                visible: root.appIconSource !== ""
                source: root.appIconSource
            }

            Rectangle {
                anchors.fill: parent
                visible: root.appIconSource === ""
                radius: Theme.mediumRadius
                color: Theme.surface0

                Icon {
                    anchors.centerIn: parent
                    icon: "notifications"
                    color: Theme.subtext0
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 3

            // app name
            StyledText {
                Layout.fillWidth: true
                text: root.notification.appName
                color: Theme.subtext0
                font.pixelSize: Theme.tinyFontSize
            }

            // summary, body and the image if there is one
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
                        font.pixelSize: Theme.mediumFontSize
                    }

                    StyledText {
                        Layout.fillWidth: true
                        visible: text !== ""
                        // no <img>, StyledText would load them from wherever the app points it
                        text: root.notification.body.replace(/<img[^>]*>/gi, "")
                        textFormat: Text.StyledText
                        wrapMode: Text.Wrap
                        maximumLineCount: 3
                        color: Theme.subtext0
                        font.pixelSize: Theme.smallFontSize
                    }
                }

                ImageTile {
                    Layout.alignment: Qt.AlignTop
                    visible: root.imageSource !== ""
                    implicitWidth: 36
                    implicitHeight: 36
                    color: "transparent"
                    source: root.imageSource
                }
            }

            // action buttons
            RowLayout {
                Layout.topMargin: 6
                Layout.bottomMargin: 4
                visible: root.defaultAction !== null || root.otherActions.length > 0
                spacing: 6

                ActionButton {
                    visible: root.defaultAction !== null
                    implicitHeight: 26
                    highlighted: true
                    text: root.defaultAction?.text || "Open"
                    onClicked: { const a = root.defaultAction; root.leave(() => a.invoke()); }
                }

                Repeater {
                    model: root.otherActions

                    ActionButton {
                        required property var modelData
                        implicitHeight: 26
                        text: modelData.text
                        onClicked: { const a = modelData; root.leave(() => a.invoke()); }
                    }
                }
            }
        }
    }
}
