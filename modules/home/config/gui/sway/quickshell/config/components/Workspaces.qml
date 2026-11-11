import QtQuick
import QtQuick.Layouts
import Quickshell.I3
import "../data"
import "ui"

// Sway workspaces with the waybar icons; click to switch
RowLayout {
    id: root

    spacing: 12

    Repeater {
        model: I3.workspaces.values.slice().sort((a, b) => a.number - b.number)

        MouseArea {
            id: ws
            required property I3Workspace modelData

            implicitWidth: label.implicitWidth
            implicitHeight: 20
            cursorShape: Qt.PointingHandCursor
            onClicked: I3.dispatch(`workspace "${modelData.name}"`)

            StyledText {
                id: label
                anchors.centerIn: parent
                text: Glyphs.workspaces[ws.modelData.name] ?? ws.modelData.name
                color: ws.modelData.urgent ? Theme.red : ws.modelData.focused ? Theme.flamingo : Theme.text
                font.bold: ws.modelData.focused
                font.pixelSize: ws.modelData.focused ? 15 : Theme.fontSize
            }
        }
    }
}
