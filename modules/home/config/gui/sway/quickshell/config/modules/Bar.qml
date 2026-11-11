import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland

import "../components"
import "../data"
import "../services"
import "../components/ui"

Scope {
  Variants {
    model: Quickshell.screens // create variants for each screen

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: Theme.barHeight
      color: "transparent"

      margins {
        top: Theme.barMargin
        left: Theme.barMargin
        right: Theme.barMargin
      }

      // keep-awake (toggle in the session hub)
      IdleInhibitor {
        window: bar
        enabled: IdleInhibit.enabled
      }

      // Background of the Bar
      Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.base
      }

      // left: workspaces + focused window
      RowLayout {
        anchors {
          left: parent.left
          leftMargin: 18
          verticalCenter: parent.verticalCenter
        }
        spacing: 24

        Workspaces { }
        Windows { screen: bar.screen }
      }

      // center: clock
      Clock {
        anchors.centerIn: parent
      }

      // right: tray | audio/network/bluetooth | brightness, battery | notifications, session
      RowLayout {
        anchors {
          right: parent.right
          rightMargin: 18
          verticalCenter: parent.verticalCenter
        }
        spacing: 18

        Tray { id: tray }
        Divider { visible: tray.visible }
        ControlGroup { }
        Divider { }

        // laptop: brightness, battery / Framework hub
        RowLayout {
          spacing: 22

          BrightnessIndicator { }
          FrameworkHub { }
        }

        Divider { }

        // notifications, session (power + keep-awake)
        RowLayout {
          spacing: 16

          NotificationIndicator { }
          SessionHub { }
        }
      }
    }
  }
}
