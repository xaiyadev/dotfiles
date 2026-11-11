pragma Singleton

import Quickshell
import QtQuick

// Keep-awake (switch in the session hub); the bar windows hold an IdleInhibitor bound to
// `enabled`, see modules/Bar.qml.
// Follows game mode: switched on when game mode starts (if it isn't on already) and off again
// when it ends, but only if game mode was the one that switched it on. Switching it by hand wins.
Singleton {
    id: root

    property bool enabled: false
    property bool byGameMode: false

    function toggle(): void {
        enabled = !enabled;
        byGameMode = false;
    }

    // called by GameMode whenever it turns on / off
    function followGameMode(gaming: bool): void {
        if (gaming && !enabled) {
            enabled = true;
            byGameMode = true;
        } else if (!gaming && byGameMode) {
            enabled = false;
            byGameMode = false;
        }
    }
}
