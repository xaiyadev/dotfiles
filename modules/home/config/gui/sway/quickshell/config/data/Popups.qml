pragma Singleton

import Quickshell
import QtQuick

// the BarPopup that is open right now, so there is only ever one open at a time
Singleton {
    property var current: null

    function toggle(popup): void { current = current === popup ? null : popup; }
    function close(popup): void { if (current === popup) current = null; }
}
