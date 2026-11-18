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
// Every popup plays a short sound.
PanelWindow {
    id: root

    readonly property var focusedScreen: Quickshell.screens.find(s => s.name === I3.focusedMonitor?.name) ?? Quickshell.screens[0]

    screen: focusedScreen
    visible: Notifications.toasts.length > 0

    anchors { top: true; right: true }
    margins { top: Theme.popupGap; right: Theme.barMargin }
    implicitWidth: 360
    implicitHeight: column.implicitHeight
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notifications"

    // short sound for every notification popup (not in do-not-disturb, those don't pop up)
    Process {
        id: sound
        command: ["sh", "-c",
            `f=$(find /nix/store -name "message-new-instant.oga" -path "*/sound-theme-freedesktop*" ! -name "*.drv" 2>/dev/null | head -1)
             [ -n "$f" ] && pw-play "$f"`
        ]
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

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                implicitHeight: card.implicitHeight
                implicitWidth: card.implicitWidth

                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                Component.onCompleted: {
                    opacity = 1;
                    sound.running = true;
                }

                Loader {
                    id: card
                    anchors.right: parent.right
                    width: parent.width
                    sourceComponent: fullCard
                }

                Component {
                    id: fullCard
                    NotificationCard { notification: toast.modelData }
                }

                Timer {
                    interval: toast.modelData.expireTimeout > 0 ? toast.modelData.expireTimeout : 5000
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
}
