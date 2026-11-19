pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire as QsPipewire
import QtQuick

Singleton {
    // without tracking them the audio properties (volume, mute) of the nodes stay empty
    QsPipewire.PwObjectTracker {
        objects: [QsPipewire.Pipewire.defaultAudioSink, QsPipewire.Pipewire.defaultAudioSource]
    }

    // output (speakers / headphones)
    readonly property QsPipewire.PwNode sink: QsPipewire.Pipewire.defaultAudioSink
    readonly property real sinkVolume: sink?.audio?.volume ?? 0
    readonly property bool sinkMuted: sink?.audio?.muted ?? false
    readonly property string sinkIcon: sinkMuted || sinkVolume <= 0 ? "volume_off"
        : sinkVolume > 0.66 ? "volume_up"
        : sinkVolume > 0.33 ? "volume_down"
        : "volume_mute"

    // all outputs to pick from, virtual ones like easyeffects included
    readonly property list<QsPipewire.PwNode> sinks: QsPipewire.Pipewire.nodes.values
        .filter(node => node.type === QsPipewire.PwNodeType.AudioSink)

    // input (microphone)
    readonly property QsPipewire.PwNode source: QsPipewire.Pipewire.defaultAudioSource
    readonly property real sourceVolume: source?.audio?.volume ?? 0
    readonly property bool sourceMuted: source?.audio?.muted ?? false
    readonly property string sourceIcon: sourceMuted ? "mic_off" : "mic"

    readonly property list<QsPipewire.PwNode> sources: QsPipewire.Pipewire.nodes.values
        .filter(node => node.type === QsPipewire.PwNodeType.AudioSource)

    function setVolume(node, volume: real): void {
        if (node?.audio) node.audio.volume = Math.max(0, Math.min(1, volume));
    }

    function toggleMute(node): void {
        if (node?.audio) node.audio.muted = !node.audio.muted;
    }

    function setDefaultSink(node): void { QsPipewire.Pipewire.preferredDefaultAudioSink = node; }

    function setDefaultSource(node): void { QsPipewire.Pipewire.preferredDefaultAudioSource = node; }
}
