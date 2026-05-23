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

      implicitHeight: 30

      Clock {
        anchors.centerIn: parent
      }
    }
  }
}