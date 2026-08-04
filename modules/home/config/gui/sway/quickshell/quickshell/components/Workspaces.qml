import QtQuick
import QtQuick.Layouts
import Quickshell.I3

Item {
    id: root

    RowLayout {
        anchors {
            left: parent.left
            leftMargin: 8
            verticalCenter: parent.verticalCenter
        }

        spacing: 8

        Repeater {
            model: I3.workspaces

            delegate: Item {
                id: workspaceItem
                required property I3Workspace modelData

                implicitWidth: 13
                implicitHeight: 13

                Text {
                    anchors.centerIn: parent
                    text: workspaceItem.modelData.name

                    color: workspaceItem.modelData.focused ? "#f2cdcd" : "#cdd6f4"
                    opacity: workspaceItem.modelData.focused ? 1.0 : 0.8

                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 14
                    }

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Behavior on opacity {
                        NumberAnimation { duration: 150 }
                    }

                }
            }
        }
    }
}
