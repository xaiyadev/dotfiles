pragma Singleton

import Quickshell
import QtQuick

// state shared across the shell: the open BarPopup and the toggles of the control popup
Singleton {
    // the BarPopup that is open right now, so there is only ever one open at a time
    property var currentPopup: null

    function togglePopup(popup): void { currentPopup = currentPopup === popup ? null : popup; }
    function closePopup(popup): void { if (currentPopup === popup) currentPopup = null; }

    // "Silent" tile, only critical notifications get a toast
    property alias doNotDisturb: persist.doNotDisturb
    // "Awake" tile; every bar window holds an IdleInhibitor bound to this, see modules/Bar.qml
    property alias idleInhibit: persist.idleInhibit

    // so the toggles survive a reload
    PersistentProperties {
        id: persist
        reloadableId: "shellState"

        property bool doNotDisturb: false
        property bool idleInhibit: false
    }
}
