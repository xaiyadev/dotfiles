import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.I3
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../components"
import "../components/ui"
import "../services"
import "../data"

// Notification popups, top right below the bar, on the focused screen.
// They disappear after a few seconds (not while hovered); critical ones stay.
// Game mode with a fullscreen window on that screen: compact cards right in the corner
// (the bar is hidden anyway) that slide in, pulse their border and stay 5 s.
// Every popup plays a short sound.
PanelWindow {
    id: root

    readonly property var focusedScreen: Quickshell.screens.find(s => s.name === I3.focusedMonitor?.name) ?? Quickshell.screens[0]
    readonly property bool focusedFullscreen: GameMode.fullscreenScreens.includes(focusedScreen?.name ?? "")
    readonly property bool gaming: GameMode.active && focusedFullscreen

    screen: focusedScreen
    visible: Notifications.toasts.length > 0

    anchors { top: true; right: true }
    margins { top: Theme.popupGap; right: Theme.barMargin }
    // while gaming right in the corner (fullscreen: the bar's space is unused)
    exclusionMode: gaming ? ExclusionMode.Ignore : ExclusionMode.Normal
    // gaming: only as wide as the cards, so the transparent rest doesn't catch clicks in the game
    implicitWidth: gaming ? Math.max(1, column.implicitWidth) : 360
    implicitHeight: column.implicitHeight
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notifications"

    // short sound for every notification popup (not in do-not-disturb, those don't pop up)
    Process {
        id: sound
        command: ["pw-play", Config.notificationSound]
    }

    ColumnLayout {
        id: column
        width: parent.width
        spacing: 8

        Repeater {
            // ScriptModel: existing toasts keep their timer / animation when another one arrives
            model: ScriptModel { values: [...Notifications.toasts] }

            Item {
                id: toast
                required property var modelData
                readonly property bool hovered: card.item?.hovered ?? false
                readonly property bool critical: modelData.urgency === NotificationUrgency.Critical
                readonly property bool gaming: root.gaming

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                implicitHeight: card.implicitHeight
                implicitWidth: card.implicitWidth

                // fade in + sound; while gaming also slide in from the right
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                transform: Translate { id: slide }
                NumberAnimation {
                    id: slideIn
                    target: slide
                    property: "x"
                    from: 80
                    to: 0
                    duration: 250
                    easing.type: Easing.OutCubic
                }

                Component.onCompleted: {
                    opacity = 1;
                    sound.running = true;
                    if (gaming) slideIn.start();
                }

                Loader {
                    id: card
                    anchors.right: parent.right
                    width: toast.gaming ? implicitWidth : parent.width
                    sourceComponent: toast.gaming ? gameCard : fullCard
                }

                Component {
                    id: fullCard
                    NotificationCard { notification: toast.modelData }
                }

                Component {
                    id: gameCard
                    GameToast { notification: toast.modelData }
                }

                Timer {
                    interval: toast.gaming ? 5000
                        : toast.modelData.expireTimeout > 0 ? toast.modelData.expireTimeout : 5000
                    running: !toast.hovered && !toast.critical
                    onTriggered: Notifications.hideToast(toast.modelData)
                }

                Connections {
                    target: toast.modelData
                    function onClosed() { Notifications.hideToast(toast.modelData) }
                }
            }
        }
    }

    // compact card for games: app icon, app name + summary, thick accent border that pulses
    component GameToast: Rectangle {
        id: gameToast
        required property Notification notification
        readonly property bool hovered: gameMouse.containsMouse

        implicitWidth: Math.min(content.implicitWidth + 28, 380)
        implicitHeight: content.implicitHeight + 20
        radius: 12
        color: Qt.rgba(Theme.base.r, Theme.base.g, Theme.base.b, hovered ? 0.98 : 0.9)
        border {
            width: 2
            color: notification.urgency === NotificationUrgency.Critical ? Theme.red : Theme.accent
        }

        // pulse the border twice when it appears
        SequentialAnimation on border.width {
            running: true
            loops: 2
            NumberAnimation { to: 4; duration: 220; easing.type: Easing.OutQuad }
            NumberAnimation { to: 2; duration: 380; easing.type: Easing.InOutQuad }
        }

        RowLayout {
            id: content
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 14 }
            spacing: 10

            IconImage {
                implicitSize: 24
                visible: gameToast.notification.appIcon !== ""
                source: gameToast.notification.appIcon !== "" ? Apps.source(gameToast.notification.appIcon, "") : ""
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                StyledText {
                    Layout.maximumWidth: 300
                    text: gameToast.notification.appName
                    color: Theme.subtext0
                    font.pixelSize: Theme.smallFontSize - 1
                }

                StyledText {
                    Layout.maximumWidth: 300
                    text: gameToast.notification.summary
                    font.bold: true
                    font.pixelSize: Theme.smallFontSize + 1
                }
            }
        }

        MouseArea {
            id: gameMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Notifications.activate(gameToast.notification)
        }
    }
}
