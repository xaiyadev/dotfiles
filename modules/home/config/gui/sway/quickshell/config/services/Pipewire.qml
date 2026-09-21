pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire as QsPipewire
import QtQuick

import '../data'

Singleton {
    id: root

    // Track the default audio sink
    QsPipewire.PwObjectTracker {
        objects: [QsPipewire.Pipewire.defaultAudioSink, QsPipewire.Pipewire.defaultAudioSource]
    }

    // Default audio sink (speakers/headphones)
    readonly property QsPipewire.PwNode sink: QsPipewire.Pipewire.defaultAudioSink
    readonly property real sinkVolume: sink?.audio?.volume ?? 0
    readonly property bool sinkMuted: sink?.audio?.muted ?? false

    // Icon based on volume and mute state for sink
    readonly property string sinkIcon: {
        if (sinkMuted) return "audio-volume-muted-symbolic";
        if (sinkVolume > 0.66) return "audio-volume-high-symbolic";
        if (sinkVolume > 0.33) return "audio-volume-medium-symbolic";
        if (sinkVolume > 0) return "audio-volume-low-symbolic";
        return "audio-volume-muted-symbolic";
    }

    // Volume percentage string
    readonly property string sinkVolumeText: Math.round(sinkVolume * 100) + "%"

    // Functions to control sink (speakers)
    function setSinkVolume(volume: real): void {
        if (sink?.audio) {
            sink.audio.volume = Math.max(0, Math.min(1, volume));
        }
    }

    // Whether the sink is in Exclusive mode or not
    readonly property bool sinkExclusive: AlsaExclusive.exclusive
}
