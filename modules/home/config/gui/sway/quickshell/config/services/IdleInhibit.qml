pragma Singleton

import Quickshell
import QtQuick

// Keep-awake (switch in the session hub); the bar windows hold an IdleInhibitor bound to
// `enabled`, see modules/Bar.qml.
Singleton {
    id: root

    property bool enabled: false

    function toggle(): void { enabled = !enabled; }
}
