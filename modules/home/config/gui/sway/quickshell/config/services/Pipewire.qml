pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire as QsPipewire
import QtQuick

import '../data'

Singleton {
    id: root

    // Track the default audio sink and source (volume / mute)
    QsPipewire.PwObjectTracker {
        objects: [QsPipewire.Pipewire.defaultAudioSink, QsPipewire.Pipewire.defaultAudioSource]
    }

    // Default audio sink (speakers/headphones)
    readonly property QsPipewire.PwNode sink: QsPipewire.Pipewire.defaultAudioSink
    readonly property real sinkVolume: sink?.audio?.volume ?? 0
    readonly property bool sinkMuted: sink?.audio?.muted ?? false
    readonly property string sinkIcon: Icons.volume(sinkVolume, sinkMuted)
    readonly property string sinkVolumeText: Math.round(sinkVolume * 100) + "%"

    // All outputs (to switch between them; includes virtual ones like EasyEffects)
    readonly property list<QsPipewire.PwNode> sinks: QsPipewire.Pipewire.nodes.values
        .filter(node => node.type === QsPipewire.PwNodeType.AudioSink)

    // Default audio source (microphone)
    readonly property QsPipewire.PwNode source: QsPipewire.Pipewire.defaultAudioSource
    readonly property real sourceVolume: source?.audio?.volume ?? 0
    readonly property bool sourceMuted: source?.audio?.muted ?? false
    readonly property string sourceIcon: sourceMuted ? "microphone-sensitivity-muted-symbolic" : "audio-input-microphone-symbolic"
    readonly property string sourceVolumeText: Math.round(sourceVolume * 100) + "%"

    // All inputs (to switch between them)
    readonly property list<QsPipewire.PwNode> sources: QsPipewire.Pipewire.nodes.values
        .filter(node => node.type === QsPipewire.PwNodeType.AudioSource)

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

    function setSourceVolume(volume: real): void {
        if (source?.audio) source.audio.volume = Math.max(0, Math.min(1, volume));
    }

    function toggleSourceMute(): void {
        if (source?.audio) source.audio.muted = !source.audio.muted;
    }

    function setDefaultSource(node): void {
        QsPipewire.Pipewire.preferredDefaultAudioSource = node;
    }

}
