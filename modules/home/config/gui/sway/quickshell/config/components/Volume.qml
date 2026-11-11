import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"
import "../data"
import "ui"

// Audio: volume in the bar (music note in exclusive mode).
// Popup, two columns like the network popup: media player left,
// volume + output selection right (hidden in exclusive mode).
BarModule {
    id: root

    // switched with a fade when exclusive mode changes
    property bool displayExclusive: Pipewire.sinkExclusive

    readonly property bool showPlayer: Mpris.selectedPlayer !== null
    readonly property bool showVolume: !Pipewire.sinkExclusive

    kind: "audio"
    icon: displayExclusive ? Icons.music : Pipewire.sinkIcon
    popupWidth: showPlayer && showVolume ? 600 : 300

    onMiddleClicked: if (Mpris.selectedPlayer?.canTogglePlaying) Mpris.selectedPlayer.togglePlaying()
    onScrolled: (delta) => {
        if (!Pipewire.sinkExclusive) Pipewire.setSinkVolume(Pipewire.sinkVolume + (delta > 0 ? 0.02 : -0.02));
    }

    SequentialAnimation {
        id: exclusiveFade
        NumberAnimation { target: root.row; property: "opacity"; to: 0; duration: 400; easing.type: Easing.OutCubic }
        ScriptAction { script: root.displayExclusive = Pipewire.sinkExclusive }
        NumberAnimation { target: root.row; property: "opacity"; to: 1; duration: 400; easing.type: Easing.OutCubic }
    }

    Connections {
        target: Pipewire
        function onSinkExclusiveChanged() { exclusiveFade.restart() }
    }

    // ---- popup ----

    // exclusive mode without a player: nothing else to show
    StyledText {
        Layout.fillWidth: true
        visible: !root.showPlayer && !root.showVolume
        text: "Exclusive mode" + (AudioFormat.text !== "" ? "  ·  " + AudioFormat.text : "")
        color: Theme.subtext0
        horizontalAlignment: Text.AlignHCenter
    }

    RowLayout {
        Layout.fillWidth: true
        visible: root.showPlayer || root.showVolume
        spacing: 16

        // ---- player ----
        MediaPanel {
            Layout.preferredWidth: 1
            Layout.alignment: Qt.AlignTop
        }

        Separator {
            vertical: true
            visible: root.showPlayer && root.showVolume
        }

        // ---- volume + outputs (PipeWire volume does nothing in exclusive mode) ----
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            visible: root.showVolume
            spacing: 6

            PanelHeader {
                Layout.bottomMargin: 4
                icon: Pipewire.sinkIcon
                title: "Output"
            }

            Repeater {
                model: Pipewire.sinks.length > 1 ? Pipewire.sinks : []

                ListItem {
                    required property var modelData
                    icon: Icons.volume(1, false)
                    text: modelData.description || modelData.name
                    active: modelData === Pipewire.sink
                    onClicked: Pipewire.setDefaultSink(modelData)
                }
            }

            // spacer: volume + Mixer sit at the bottom, level with the player controls
            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Icon {
                    icon: Pipewire.sinkIcon
                    size: 16
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Pipewire.toggleSinkMute()
                    }
                }

                Slider {
                    Layout.fillWidth: true
                    value: Pipewire.sinkVolume
                    onMoved: (value) => Pipewire.setSinkVolume(value)
                }

                StyledText {
                    Layout.preferredWidth: 36
                    text: Pipewire.sinkVolumeText
                    color: Theme.subtext0
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: Theme.smallFontSize
                }
            }

            ActionButton {
                Layout.topMargin: 8
                Layout.alignment: Qt.AlignRight
                icon: "preferences-system-symbolic"
                text: "Mixer"
                // pwvucontrol (PipeWire), pavucontrol as fallback
                onClicked: Quickshell.execDetached(["sh", "-c", "command -v pwvucontrol >/dev/null && exec pwvucontrol || exec pavucontrol"])
            }
        }
    }
}
