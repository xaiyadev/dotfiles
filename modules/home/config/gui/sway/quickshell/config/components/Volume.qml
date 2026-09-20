import QtQuick
import Quickshell
import Quickshell.Widgets
import "../services"

Item {
    id: root

    IconImage {
        id: volumeIcon
        implicitSize: 16

        anchors {
          right: volumeText.left
          rightMargin: 6
          verticalCenter: parent.verticalCenter
        }

        source: Quickshell.iconPath("audio-volume-high-symbolic")
    }
}
