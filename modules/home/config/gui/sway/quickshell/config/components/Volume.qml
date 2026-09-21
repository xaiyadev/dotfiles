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

      property bool displayExclusive: Pipewire.sinkExclusive

      icon: displayExclusive ? "folder-music-symbolic" : Pipewire.sinkIcon
      size: 18
    }

    // exclusive on/off animation
    SequentialAnimation {
        id: exclusiveFade

        NumberAnimation { target: volumeIcon; property: "opacity"; to: 0; duration: 400; easing.type: Easing.OutCubic }
        ScriptAction { script: volumeIcon.displayExclusive = Pipewire.sinkExclusive }
        NumberAnimation { target: volumeIcon; property: "opacity"; to: 1; duration: 400; easing.type: Easing.OutCubic }
    }

    Connections {
        target: Pipewire
        function onSinkExclusiveChanged() { exclusiveFade.restart() }
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
