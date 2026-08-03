import QtQuick
import QtQuick.Layouts
import Quickshell.I3

Item {
    id: root

    RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Repeater {
            model: I3.workspaces

            delegate: Rectangle {
                id: wsDelegate
                required property I3Workspace modelData

                implicitWidth: 13
                implicitHeight: 13
                radius: 4

                color: "#1e1e2e"

                Text {
                    anchors.centerIn: parent
                    text: wsDelegate.modelData.name

                    color: modelData.focused ? "#f2cdcd" : "#cdd6f4"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                }
            }
        }
    }
}
