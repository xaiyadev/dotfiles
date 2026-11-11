pragma Singleton

import Quickshell
import QtQuick

// Which bar popup is open. Only one at a time: opening one closes the other.
Singleton {
    id: root

    property var current: null

    // e.g. "audio", "network": services use this to only poll while their popup is open
    readonly property string currentKind: typeof current?.kind === "string" ? current.kind : ""

    function toggle(popup): void { current = current === popup ? null : popup; }
    function close(popup): void { if (current === popup) current = null; }
}
