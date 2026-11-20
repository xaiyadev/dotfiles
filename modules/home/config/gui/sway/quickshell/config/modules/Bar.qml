pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

import qs.components
import qs.components.controlGroup
import qs.components.ui
import qs.data

Scope {
    Variants {
        model: Quickshell.screens // one bar per screen

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }

            implicitHeight: Theme.barHeight
            color: "transparent"
            WlrLayershell.namespace: "quickshell-bar"

            margins { top: Theme.barMargin; left: Theme.barMargin; right: Theme.barMargin }

            // keep-awake, toggled by the "Awake" tile in the control popup
            IdleInhibitor {
                window: bar
                enabled: ShellState.idleInhibit
            }

            Rectangle {
                anchors.fill: parent
                radius: Theme.radius
                color: Theme.base
            }

            Workspaces {
                monitorName: bar.modelData.name
                anchors { left: parent.left; leftMargin: 18; verticalCenter: parent.verticalCenter }
            }

            Clock {
                anchors.centerIn: parent
            }

            // tray | volume, network, notifications, battery (click for the control popup)
            RowLayout {
                anchors { right: parent.right; rightMargin: 18; verticalCenter: parent.verticalCenter }
                spacing: 18

                Tray { id: tray }
                Separator { vertical: true; visible: tray.visible }
                ControlGroup { }
            }
        }
    }
}
