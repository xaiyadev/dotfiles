pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.I3
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../components"
import "../services"
import "../data"

// notification popups top right below the bar on the focused screen; they go away after a
// few seconds (not while hovered), critical ones stay until clicked away
PanelWindow {
    id: root

    screen: Quickshell.screens.find(s => s.name === I3.focusedMonitor?.name) ?? Quickshell.screens[0]
    visible: Notifications.toasts.length > 0

    anchors { top: true; right: true }
    margins { top: Theme.popupGap; right: Theme.barMargin }
    implicitWidth: 360
    implicitHeight: column.implicitHeight
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notifications"

    // short sound for every toast; do-not-disturb only lets critical ones through, those still make the sound
    Process {
        id: sound
        command: ["pw-play", Config.notificationSound]
    }

    ColumnLayout {
        id: column
        width: parent.width
        spacing: 8

        Repeater {
            // ScriptModel so already shown toasts keep their timer and animation when a new one comes in
            model: ScriptModel { values: [...Notifications.toasts] }

            // wrapper fades in, the card itself animates out on leave()
            Item {
                id: toast
                required property var modelData

                Layout.fillWidth: true
                implicitHeight: card.implicitHeight

                opacity: 0
                Behavior on opacity { NumberAnimation { duration: Theme.mediumAnimation } }

                Component.onCompleted: {
                    opacity = 1;
                    sound.running = true;
                }

                NotificationCard {
                    id: card
                    width: parent.width
                    notification: toast.modelData
                    isToast: true
                    onHoveredChanged: Notifications.setToastHovered(toast.modelData, hovered)
                }

                // expireTimeout is in seconds; unset (-1) and 0 ("never") both get 5s so nothing stays up forever
                Timer {
                    interval: toast.modelData.expireTimeout > 0 ? toast.modelData.expireTimeout * 1000 : 5000
                    running: !card.hovered && toast.modelData.urgency !== NotificationUrgency.Critical
                    onTriggered: {
                        const n = toast.modelData;
                        card.leave(() => Notifications.hideToast(n));
                    }
                }
            }
        }
    }
}
