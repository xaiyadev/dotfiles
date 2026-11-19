pragma Singleton

import Quickshell
import QtQuick

// keep-awake ("Awake" tile in the control popup); every bar window holds an IdleInhibitor
// bound to `enabled`, see modules/Bar.qml
Singleton {
    property bool enabled: false
}
