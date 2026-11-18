pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

// history: all received notifications (newest first), cleared only via clearAll(); toasts: currently shown popups.
Singleton {
    id: root

    property bool doNotDisturb: false

    property var history: []
    readonly property int count: history.length

    // notifications shown as toasts right now
    property var toasts: []

    // receive time per notification id (Notification has no timestamp)
    // (entries are removed when the notification closes, see onNotification)
    property var receivedAt: ({})

    // "now" for the relative times, ticks every 30 s so "now" / "3 min" stay current
    property real now: Date.now()

    Timer {
        interval: 30000
        running: root.count > 0
        repeat: true
        onTriggered: root.now = Date.now()
    }

    function timeOf(notification): string {
        const t = receivedAt[notification.id];
        if (!t) return "";
        const minutes = Math.floor((now - t) / 60000);
        if (minutes < 1) return "now";
        if (minutes < 60) return minutes + " min";
        return Qt.formatTime(new Date(t), "HH:mm");
    }

    function hideToast(notification): void {
        toasts = toasts.filter(n => n !== notification);
    }

    // click on a notification: run its default action if it has one
    function activate(notification): void {
        const action = notification.actions.find(a => a.identifier === "default");
        if (action) action.invoke();
        else notification.dismiss();
    }

    function clearAll(): void {
        const all = [...history];
        history = [];
        toasts = [];
        for (const n of all) n.dismiss();
    }

    // command line / keybinds: qs ipc call notifications toggleDnd | dnd | count | clear | list
    IpcHandler {
        target: "notifications"

        function toggleDnd(): void { root.doNotDisturb = !root.doNotDisturb; }
        function dnd(): bool { return root.doNotDisturb; }
        function count(): int { return root.count; }
        function clear(): void { root.clearAll(); }
        function list(): string {
            return root.history.map(n => [n.id, n.appName, n.summary, "urgency=" + n.urgency,
                "expire=" + n.expireTimeout, "transient=" + n.transient, "image=" + n.image,
                "icon=" + n.appIcon, "toast=" + root.toasts.includes(n)].join(" | ")).join("\n");
        }
    }

    NotificationServer {
        id: server

        keepOnReload: true
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: (notification) => {
            notification.tracked = true;
            root.now = Date.now();
            const id = notification.id;
            root.receivedAt[id] = root.now;
            root.history = [notification, ...root.history];
            notification.closed.connect(() => {
                root.history = root.history.filter(n => n !== notification);
                root.toasts = root.toasts.filter(n => n !== notification);
            });
            if (!root.doNotDisturb || notification.urgency === NotificationUrgency.Critical)
                root.toasts = [...root.toasts, notification].slice(-4);
        }
    }
}
