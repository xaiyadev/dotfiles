import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris as QsMpris
import qs.services
import qs.data
import qs.components.ui

// cover, player name, title / artist, controls and progress of the selected mpris player
ColumnLayout {
    id: root

    readonly property QsMpris.MprisPlayer player: Mpris.selectedPlayer
    // position polling only runs while this is true, ControlPopup binds it to its visibility
    property bool polling: false

    readonly property real trackPosition: player?.position ?? 0

    function formatTime(secs: real): string {
        const s = Math.floor(secs);
        const m = Math.floor(s / 60);
        return m + ":" + String(s % 60).padStart(2, "0");
    }

    // mpris only tells us about the position on seeks, so we ask for it every second while
    // playing and the popup is open (this is how the quickshell docs do it)
    Timer {
        running: root.polling && (root.player?.isPlaying ?? false)
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: root.player.positionChanged()
    }

    Layout.fillWidth: true
    spacing: 10

    // cover on the left, info and controls on the right
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        ImageTile {
            Layout.alignment: Qt.AlignTop
            implicitWidth: 100
            implicitHeight: 100
            source: root.player ? root.player.trackArtUrl : ""
            fallbackIcon: "music_note"
            fallbackSize: 36
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
                }

                IconImage {
                    implicitSize: Theme.smallIconSize
                    source: Mpris.playerIconPath
                }
            }

            StyledText {
                Layout.fillWidth: true
                Layout.topMargin: 2
                text: root.player?.trackTitle ?? ""
                font.pixelSize: Theme.mediumFontSize
                font.bold: true
            }

            StyledText {
                Layout.fillWidth: true
                text: root.player?.trackArtist ?? ""
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize
            }

            Item { Layout.fillHeight: true; implicitHeight: 4 }

            // controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                ControlButton {
                    icon: "shuffle"
                    enabled: root.player?.shuffleSupported ?? false
                    active: root.player?.shuffle ?? false
                    onClicked: if (root.player) root.player.shuffle = !root.player.shuffle
                }

                ControlButton {
                    Layout.leftMargin: 8
                    icon: "skip_previous"
                    enabled: root.player?.canGoPrevious ?? false
                    onClicked: root.player.previous()
                }

                ControlButton {
                    icon: root.player?.isPlaying ? "pause" : "play_arrow"
                    size: 24
                    enabled: root.player?.canTogglePlaying ?? false
                    onClicked: root.player.togglePlaying()
                }

                ControlButton {
                    icon: "skip_next"
                    enabled: root.player?.canGoNext ?? false
                    onClicked: root.player.next()
                }

                ControlButton {
                    Layout.leftMargin: 8
                    icon: root.player?.loopState === QsMpris.MprisLoopState.Track
                        ? "repeat_one" : "repeat"
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

    // progress bar over the full width
    Slider {
        id: progressBar
        Layout.fillWidth: true
        visible: (root.player?.lengthSupported ?? false) && (root.player?.length ?? 0) > 0
        value: (root.player?.length ?? 0) > 0 ? Math.min(1, root.trackPosition / root.player.length) : 0
        live: false
        onMoved: (v) => {
            if (root.player?.canSeek) {
                root.player.position = v * root.player.length;
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        visible: progressBar.visible

        StyledText {
            // where it would seek to while dragging
            text: root.formatTime(progressBar.dragging ? progressBar.dragValue * root.player.length : root.trackPosition)
            color: Theme.subtext0
            font.pixelSize: Theme.tinyFontSize
        }

        Item { Layout.fillWidth: true }

        StyledText {
            text: root.formatTime(root.player?.length ?? 0)
            color: Theme.subtext0
            font.pixelSize: Theme.tinyFontSize
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
            Behavior on scale { NumberAnimation { duration: Theme.fastAnimation } }
        }

        ClickArea { id: mouse; onClicked: btn.clicked() }
    }
}
