pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

// keeps every notification (newest first) until it gets dismissed or cleared, plus the ones
// that are shown as toasts right now
Singleton {
    id: root

    readonly property int maxToasts: 4
    // older ones than that expire on their own
    readonly property int maxHistory: 50

    property bool doNotDisturb: false

    property var history: []
    readonly property int count: history.length

    // the ones shown as toasts right now, oldest first
    property var toasts: []

    // toasts the mouse is on; a new toast pushes out the oldest one that isnt hovered so
    // nothing disappears while you are reading it
    property var hoveredToasts: []

    // when we got each notification (by id), Notification itself has no timestamp
    property var receivedAt: ({})

    // ticks every 30s while there are notifications so the age groups in the history dont get stale
    property real now: Date.now()

    Timer {
        interval: 30000
        running: root.count > 0
        repeat: true
        onTriggered: root.now = Date.now()
    }

    // the group a notification is shown under in the history ("Just now", "Last 15 min", ...)
    function ageGroup(notification): string {
        const t = receivedAt[notification?.id];
        if (!t) return "Earlier";
        const minutes = (now - t) / 60000;
        if (minutes < 1) return "Just now";
        if (minutes < 5) return "Few minutes ago";
        if (minutes < 15) return "Last 15 min";
        if (minutes < 30) return "Last 30 min";
        if (minutes < 60) return "Last hour";
        const received = new Date(t);
        const today = new Date(now);
        today.setHours(0, 0, 0, 0);
        if (received >= today) return "Today";
        if (received >= today - 86400000) return "Yesterday";
        return "Older";
    }

    function showToast(notification): void {
        let list = [...toasts, notification];
        while (list.length > maxToasts) {
            const out = list.find(n => !hoveredToasts.includes(n)) ?? list[0];
            list = list.filter(n => n !== out);
        }
        toasts = list;
        hoveredToasts = hoveredToasts.filter(n => list.includes(n));
    }

    function hideToast(notification): void {
        toasts = toasts.filter(n => n !== notification);
        hoveredToasts = hoveredToasts.filter(n => n !== notification);
    }

    function setToastHovered(notification, hovered: bool): void {
        const others = hoveredToasts.filter(n => n !== notification);
        hoveredToasts = hovered ? [...others, notification] : others;
    }

    function clearAll(): void {
        const all = [...history];
        history = [];
        toasts = [];
        hoveredToasts = [];
        for (const n of all) n.dismiss();
    }

    // the server keeps tracked notifications over a reload but our list starts empty again;
    // we dont know when those came in, so they end up under "Earlier"
    Component.onCompleted: {
        const kept = server.trackedNotifications.values.slice().reverse();
        for (const n of kept) root.track(n);
        root.history = kept;
        root.trimHistory();
    }

    // expiring closes it, so track() takes it out of the history
    function trimHistory(): void {
        for (const n of history.slice(maxHistory)) n.expire();
    }

    // drops it everywhere once its closed (dismissed, expired or closed by the app)
    function track(notification): void {
        const id = notification.id;
        notification.closed.connect(() => {
            delete root.receivedAt[id];
            root.history = root.history.filter(n => n !== notification);
            root.hideToast(notification);
        });
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
            root.receivedAt[notification.id] = root.now;
            root.track(notification);
            root.history = [notification, ...root.history];
            root.trimHistory();
            if (!root.doNotDisturb || notification.urgency === NotificationUrgency.Critical)
                root.showToast(notification);
        }
    }
}
