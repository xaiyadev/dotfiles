pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.I3
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import qs.components
import qs.services
import qs.data

PanelWindow {
    id: root

    readonly property int maxToasts: 4

    // shown notifications, oldest first
    property var toasts: []
    property var hoveredToasts: []

    function show(notification): void {
        if (toasts.length >= maxToasts)
            hide(toasts.find(n => !hoveredToasts.includes(n)) ?? toasts[0]);
        toasts = [...toasts, notification];
    }

    function hide(notification): void {
        toasts = toasts.filter(n => n !== notification);
        hoveredToasts = hoveredToasts.filter(n => n !== notification);
    }

    function setHovered(notification, hovered: bool): void {
        const others = hoveredToasts.filter(n => n !== notification);
        hoveredToasts = hovered ? [...others, notification] : others;
    }

    Connections {
        target: Notifications

        function onNotified(notification): void {
            if (ShellState.doNotDisturb && notification.urgency !== NotificationUrgency.Critical) return;

            notification.closed.connect(() => root.hide(notification));
            root.show(notification);
        }
    }

    screen: Quickshell.screens.find(s => s.name === I3.focusedMonitor?.name) ?? Quickshell.screens[0]
    visible: toasts.length > 0

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
            model: ScriptModel { values: root.toasts }

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
                    onHoveredChanged: root.setHovered(toast.modelData, hovered)
                    onHidden: root.hide(toast.modelData)
                }

                Timer {
                    interval: toast.modelData.expireTimeout > 0 ? toast.modelData.expireTimeout * 1000 : 5000
                    running: !card.hovered && toast.modelData.urgency !== NotificationUrgency.Critical
                    onTriggered: {
                        const n = toast.modelData;
                        card.leave(() => root.hide(n));
                    }
                }
            }
        }
    }
}
