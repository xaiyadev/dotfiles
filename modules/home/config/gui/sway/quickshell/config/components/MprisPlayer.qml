import QtQuick
import "../services"

Item {
    id: root

    readonly property bool hasPlayer: Mpris.selectedPlayer !== null

    implicitWidth: hasPlayer ? label.implicitWidth : 0
    implicitHeight: 20
    clip: true

    Text {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: "#cdd6f4"

        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 15
        }

        readonly property string value: Mpris.selectedPlayer ? (Mpris.selectedPlayer.trackTitle + " - " + Mpris.selectedPlayer.trackArtist) : ""
        text: value.length > 20 ? value.slice(0, 20) + "..." : value
    }

    // song width change animation
    Behavior on implicitWidth {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.hasPlayer

        onClicked: if (Mpris.selectedPlayer?.canTogglePlaying) Mpris.selectedPlayer.togglePlaying();
    }
}
