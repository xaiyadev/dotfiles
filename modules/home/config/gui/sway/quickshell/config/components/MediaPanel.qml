import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris as QsMpris
import "../services"
import "../data"
import "ui"

// Player name, cover, title / artist, source format and controls of the selected MPRIS player
ColumnLayout {
    id: root

    readonly property var player: Mpris.selectedPlayer

    Layout.fillWidth: true
    spacing: 10
    visible: player !== null

    // --- player icon + name ---
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 8

        IconImage {
            implicitSize: 18
            source: Mpris.playerIconPath
        }

        StyledText {
            text: root.player?.identity ?? ""
            color: Theme.subtext0
            font.pixelSize: Theme.smallFontSize + 1
        }
    }

    // --- cover ---
    ClippingRectangle {
        Layout.alignment: Qt.AlignHCenter
        implicitWidth: 240
        implicitHeight: 240
        radius: 10
        color: Theme.surface0

        Image {
            id: cover
            anchors.fill: parent
            source: root.player?.trackArtUrl ?? ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            sourceSize { width: 480; height: 480 }
        }

        Icon {
            anchors.centerIn: parent
            visible: cover.status !== Image.Ready
            icon: Icons.music
            size: 64
        }
    }

    // --- title / artist ---
    StyledText {
        Layout.fillWidth: true
        Layout.topMargin: 4
        text: root.player?.trackTitle ?? ""
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 15
        font.bold: true
    }

    StyledText {
        Layout.fillWidth: true
        Layout.topMargin: -6
        text: root.player?.trackArtist ?? ""
        color: Theme.subtext0
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.smallFontSize + 1
    }

    // --- bit depth / sample rate ---
    StyledText {
        Layout.fillWidth: true
        visible: AudioFormat.text !== ""
        text: AudioFormat.text
        color: Theme.overlay0
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.smallFontSize
    }

    // --- media controls ---
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 4
        spacing: 18

        ControlButton {
            icon: "media-playlist-shuffle-symbolic"
            visible: root.player?.shuffleSupported ?? false
            active: root.player?.shuffle ?? false
            onClicked: root.player.shuffle = !root.player.shuffle
        }

        ControlButton {
            icon: "media-skip-backward-symbolic"
            enabled: root.player?.canGoPrevious ?? false
            onClicked: root.player.previous()
        }

        ControlButton {
            icon: root.player?.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
            size: 26
            enabled: root.player?.canTogglePlaying ?? false
            onClicked: root.player.togglePlaying()
        }

        ControlButton {
            icon: "media-skip-forward-symbolic"
            enabled: root.player?.canGoNext ?? false
            onClicked: root.player.next()
        }

        ControlButton {
            icon: root.player?.loopState === QsMpris.MprisLoopState.Track
                ? "media-playlist-repeat-song-symbolic" : "media-playlist-repeat-symbolic"
            visible: root.player?.loopSupported ?? false
            active: (root.player?.loopState ?? QsMpris.MprisLoopState.None) !== QsMpris.MprisLoopState.None
            onClicked: {
                const s = root.player.loopState;
                root.player.loopState = s === QsMpris.MprisLoopState.None ? QsMpris.MprisLoopState.Playlist
                    : s === QsMpris.MprisLoopState.Playlist ? QsMpris.MprisLoopState.Track
                    : QsMpris.MprisLoopState.None;
            }
        }
    }

    component ControlButton: Item {
        id: btn
        property string icon
        property int size: 20
        property bool active: true
        signal clicked()

        implicitWidth: size + 8
        implicitHeight: size + 8
        opacity: !enabled ? 0.3 : (active ? 1 : 0.5)

        Icon {
            anchors.centerIn: parent
            icon: btn.icon
            size: btn.size
            scale: mouse.pressed ? 0.85 : (mouse.containsMouse ? 1.1 : 1)
            Behavior on scale { NumberAnimation { duration: 120 } }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.clicked()
        }
    }
}
