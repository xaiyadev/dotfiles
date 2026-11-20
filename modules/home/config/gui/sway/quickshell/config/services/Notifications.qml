pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

// keeps every notification (newest first) until it gets dismissed or cleared; the popups are in modules/Toasts.qml
Singleton {
    id: root

    readonly property int maxHistory: 50

    // { notification, time } entries
    property var history: []
    readonly property int count: history.length

    // every new notification, modules/Toasts.qml decides if it gets a toast
    signal notified(notification: Notification)

    property real now: Date.now()

    Timer {
        interval: 30000
        running: root.count > 0
        repeat: true
        onTriggered: root.now = Date.now()
    }

    // groups in the notification hub
    function ageGroup(time: real): string {
        const minutes = (now - time) / 60000;
        if (minutes < 1) return "Just now";
        if (minutes < 5) return "Few minutes ago";
        if (minutes < 15) return "Last 15 min";
        if (minutes < 30) return "Last 30 min";
        if (minutes < 60) return "Last hour";
        const today = new Date(now);
        today.setHours(0, 0, 0, 0);
        if (time >= today.getTime()) return "Today";
        if (time >= today.getTime() - 86400000) return "Yesterday";
        return "Older";
    }

    function clearAll(): void {
        for (const e of history) e.notification.dismiss();
    }

    function add(notification): void {
        notification.tracked = true;

        notification.closed.connect(() => {
            root.history = root.history.filter(e => e.notification !== notification);
        });

        now = Date.now();
        history = [{ notification, time: now }, ...history];

        for (const e of history.slice(maxHistory)) e.notification.expire();
    }

    NotificationServer {
        keepOnReload: false
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: (notification) => {
            root.add(notification);
            root.notified(notification);
        }
    }
}
