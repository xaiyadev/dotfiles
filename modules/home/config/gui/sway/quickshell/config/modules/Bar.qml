import Quickshell
import Quickshell.Io
import QtQuick.Layouts
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
        radius: 12
        color: "#1e1e2e"
      }

      // modules
      RowLayout {
        anchors {
          left: parent.left
          leftMargin: 15

          verticalCenter: parent.verticalCenter
        }

        height: 20
        spacing: 10

        Workspaces { }
      }

      RowLayout {
        anchors {
          horizontalCenter: parent.horizontalCenter
          verticalCenter: parent.verticalCenter
        }

        height: 20
        spacing: 10

        Clock { }
      }

      RowLayout {
        anchors {
          right: parent.right
          rightMargin: 15

          verticalCenter: parent.verticalCenter
        }

        height: 20
        spacing: 10

        Volume { }
        MprisPlayer { }
      }
    }
  }
}
