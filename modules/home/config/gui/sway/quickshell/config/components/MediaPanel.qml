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

    // local estimate so the bar advances every second without waiting for MPRIS position events
    property real trackPosition: player?.position ?? 0

    function formatTime(secs: real): string {
        const s = Math.floor(secs);
        const m = Math.floor(s / 60);
        return m + ":" + String(s % 60).padStart(2, "0");
    }

    Connections {
        target: root.player
        function onPositionChanged() { root.trackPosition = root.player.position; }
    }

    Timer {
        running: root.player?.isPlaying ?? false
        interval: 1000
        repeat: true
        onTriggered: root.trackPosition += 1
    }

    Layout.fillWidth: true
    spacing: 10

    // --- cover (left) + metadata/controls (right) ---
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        ClippingRectangle {
            implicitWidth: 100
            implicitHeight: 100
            radius: 8
            color: Theme.surface0
            Layout.alignment: Qt.AlignTop

            Image {
                id: cover
                anchors.fill: parent
                source: root.player?.trackArtUrl ?? ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize { width: 200; height: 200 }
            }

            Icon {
                anchors.centerIn: parent
                visible: cover.status !== Image.Ready
                icon: Icons.music
                size: 36
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: 2

            // player name (left) + app icon (right)
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                StyledText {
                    Layout.fillWidth: true
                    text: root.player?.identity ?? ""
                    color: Theme.subtext0
                    font.pixelSize: Theme.smallFontSize
                    elide: Text.ElideRight
                }

                IconImage {
                    implicitSize: 16
                    source: Mpris.playerIconPath
                }
            }

            StyledText {
                Layout.fillWidth: true
                Layout.topMargin: 2
                text: root.player?.trackTitle ?? ""
                font.pixelSize: Theme.fontSize - 1
                font.bold: true
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                text: root.player?.trackArtist ?? ""
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize
                elide: Text.ElideRight
            }

            Item { Layout.fillHeight: true; implicitHeight: 4 }

            // controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                ControlButton {
                    icon: "media-playlist-shuffle-symbolic"
                    enabled: root.player?.shuffleSupported ?? false
                    active: root.player?.shuffle ?? false
                    onClicked: if (root.player) root.player.shuffle = !root.player.shuffle
                }

                ControlButton {
                    Layout.leftMargin: 8
                    icon: "media-skip-backward-symbolic"
                    enabled: root.player?.canGoPrevious ?? false
                    onClicked: root.player.previous()
                }

                ControlButton {
                    icon: root.player?.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
                    size: 24
                    enabled: root.player?.canTogglePlaying ?? false
                    onClicked: root.player.togglePlaying()
                }

                ControlButton {
                    icon: "media-skip-forward-symbolic"
                    enabled: root.player?.canGoNext ?? false
                    onClicked: root.player.next()
                }

                ControlButton {
                    Layout.leftMargin: 8
                    icon: root.player?.loopState === QsMpris.MprisLoopState.Track
                        ? "media-playlist-repeat-song-symbolic" : "media-playlist-repeat-symbolic"
                    enabled: root.player?.loopSupported ?? false
                    active: (root.player?.loopState ?? QsMpris.MprisLoopState.None) !== QsMpris.MprisLoopState.None
                    onClicked: {
                        if (!root.player) return;
                        const s = root.player.loopState;
                        root.player.loopState = s === QsMpris.MprisLoopState.None ? QsMpris.MprisLoopState.Playlist
                            : s === QsMpris.MprisLoopState.Playlist ? QsMpris.MprisLoopState.Track
                            : QsMpris.MprisLoopState.None;
                    }
                }
            }
        }
    }

    // --- progress bar (full width, below cover+content row) ---
    Slider {
        id: progressBar
        Layout.fillWidth: true
        visible: (root.player?.lengthSupported ?? false) && (root.player?.length ?? 0) > 0
        value: root.player?.length > 0 ? Math.min(1, root.trackPosition / root.player.length) : 0
        onMoved: (v) => {
            if (root.player?.canSeek) {
                root.player.position = v * root.player.length;
                root.trackPosition = v * root.player.length;
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        visible: progressBar.visible

        StyledText {
            text: root.formatTime(root.trackPosition)
            color: Theme.subtext0
            font.pixelSize: Theme.smallFontSize - 2
        }

        Item { Layout.fillWidth: true }

        StyledText {
            text: root.formatTime(root.player?.length ?? 0)
            color: Theme.subtext0
            font.pixelSize: Theme.smallFontSize - 2
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
