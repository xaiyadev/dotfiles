import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import "../services"

Item {
    id: root

    implicitWidth: 20
    implicitHeight: 20

    Icon {
      id: volumeIcon
      anchors.centerIn: parent
      icon: Pipewire.sinkExclusive ? "folder-music-symbolic" : Pipewire.sinkIcon
      size: 18
    }

    // on scroll -> change pulsewire audio
    MouseArea {
        anchors.fill: parent
        enabled: !Pipewire.sinkExclusive

        onWheel: (wheel) => {
            const step = 0.02;
            Pipewire.setSinkVolume(Pipewire.sinkVolume + (wheel.angleDelta.y > 0 ? step : -step));
        }
    }
}
