import Quickshell
import Quickshell.Io
import QtQuick

import "../components"

Scope {
  Variants {
    model: Quickshell.screens // create variants for each screen

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 36
      color: "transparent"

      margins {
        top: 10
        left: 10
        right: 10
      }

      // Background of the Bar
      Rectangle {
        anchors.fill: parent
        radius: 8
        color: "#1e1e2e"
      }

      Workspaces {
        anchors.fill: parent
      }

      Clock {
        anchors.fill: parent
      }
    }
  }
}
