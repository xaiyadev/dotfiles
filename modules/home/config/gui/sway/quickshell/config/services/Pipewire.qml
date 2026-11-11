pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire as QsPipewire
import QtQuick

import '../data'

Singleton {
    id: root

    // Track the default audio sink (volume / mute)
    QsPipewire.PwObjectTracker {
        objects: [QsPipewire.Pipewire.defaultAudioSink]
    }

    // Default audio sink (speakers/headphones)
    readonly property QsPipewire.PwNode sink: QsPipewire.Pipewire.defaultAudioSink
    readonly property real sinkVolume: sink?.audio?.volume ?? 0
    readonly property bool sinkMuted: sink?.audio?.muted ?? false

    // icon for the volume / mute state (data/Icons.qml)
    readonly property string sinkIcon: Icons.volume(sinkVolume, sinkMuted)

    // Volume percentage string
    readonly property string sinkVolumeText: Math.round(sinkVolume * 100) + "%"

    // All outputs (to switch between them; includes virtual ones like EasyEffects)
    readonly property list<QsPipewire.PwNode> sinks: QsPipewire.Pipewire.nodes.values
        .filter(node => node.type === QsPipewire.PwNodeType.AudioSink)

    // capture streams and the connections into them: tracked, otherwise their properties
    // (media.name, needed for the "Peak detect" filter) and link states are unknown
    QsPipewire.PwObjectTracker {
        objects: [
            ...QsPipewire.Pipewire.nodes.values.filter(node => node.type === QsPipewire.PwNodeType.AudioInStream),
            ...QsPipewire.Pipewire.linkGroups.values.filter(group => group.target?.type === QsPipewire.PwNodeType.AudioInStream)
        ]
    }

    // Apps currently recording audio (microphone in use): capture streams with an *active*
    // connection (paused / idle ones don't count). Works with EasyEffects in between, the
    // apps record from its virtual source. Mixer level meters ("Peak detect") are ignored.
    readonly property list<QsPipewire.PwNode> recordingStreams: {
        const active = QsPipewire.Pipewire.linkGroups.values
            .filter(group => group.state === QsPipewire.PwLinkState.Active)
            .map(group => group.target);

        return QsPipewire.Pipewire.nodes.values
            .filter(node => node.type === QsPipewire.PwNodeType.AudioInStream
                && !(node.properties["media.name"] ?? "").toLowerCase().includes("peak detect")
                && active.includes(node));
    }

    function streamAppName(node): string {
        return node.properties["application.name"] || node.description || node.name;
    }

    // Functions to control sink (speakers)
    function setSinkVolume(volume: real): void {
        if (sink?.audio) {
            sink.audio.volume = Math.max(0, Math.min(1, volume));
        }
    }

    function toggleSinkMute(): void {
        if (sink?.audio) sink.audio.muted = !sink.audio.muted;
    }

    function setDefaultSink(node): void {
        QsPipewire.Pipewire.preferredDefaultAudioSink = node;
    }

    // Whether the sink is in Exclusive mode or not
    readonly property bool sinkExclusive: AlsaExclusive.exclusive
}
