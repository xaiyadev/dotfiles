import QtQuick
import QtQuick.Layouts
import Quickshell.I3

Item {
    id: root

    RowLayout {
        spacing: 8

        Repeater {
            model: I3.workspaces

            delegate: Rectangle {
                required property I3Workspace modelData
                id: wsDelegate

                implicitWidth: 10
                color: "#1e1e2e"

                Text {
                    anchors.centerIn: parent
                    text: wsDelegate.modelData.name

                    color: modelData.focused ? "#f2cdcd" : "#cdd6f4"

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 14
                    }
                }
            }
        }
    }
}
