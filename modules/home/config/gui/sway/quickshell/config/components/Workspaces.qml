pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.I3
import "../data"
import "ui"

// workspaces of one monitor; the focused one in bold, the one shown on this monitor (while
// another monitor has focus) in the accent too
RowLayout {
    id: root

    // output name of the screen the bar is on
    required property string monitorName

    spacing: 12

    Repeater {
        model: ScriptModel {
            values: I3.workspaces.values
                .filter(w => w.monitor?.name === root.monitorName)
                .sort((a, b) => a.number - b.number)
        }

        MouseArea {
            id: ws
            required property I3Workspace modelData

            implicitWidth: label.implicitWidth
            implicitHeight: 20
            cursorShape: Qt.PointingHandCursor
            onClicked: modelData.activate()

            StyledText {
                id: label
                anchors.centerIn: parent
                // workspace 10 is on the 0 key; ones without a number (-1) show their name
                text: ws.modelData.number === 10 ? "0"
                    : ws.modelData.number >= 0 ? String(ws.modelData.number)
                    : ws.modelData.name
                color: ws.modelData.urgent ? Theme.red
                    : ws.modelData.focused || ws.modelData.active ? Theme.accent
                    : Theme.text
                font.bold: ws.modelData.focused
            }
        }
    }
}
