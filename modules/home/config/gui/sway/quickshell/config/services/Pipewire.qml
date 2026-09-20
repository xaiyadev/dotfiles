pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire as QsPipewire
import QtQuick

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

    // Whether some other process is currently holding the default output
    // meaning alsa or exclusive mode
    // TODO: work this out
    // TODO: in a different service?
    property bool sinkExclusive: false

    Process {
        id: exclusiveCheck

        command: ["sh", "-c", `
            sink=$(pactl get-default-sink)
            card=$(printf '%s' "$sink" | sed -E 's/^alsa_output\\.//; s/\\.[^.]*$//')
            alsanum=$(pactl list cards | awk -v RS='' -v pat="alsa_card.$card" '$0 ~ pat' | grep -m1 'alsa.card = ' | awk -F'"' '{print $2}')

            if [ -z "$alsanum" ]; then echo false; exit; fi

            pat=$(printf 'pcmC%sD' "$alsanum")
            holder=""

            for l in $(find /proc -maxdepth 3 -path '*/fd/*' -type l -lname "*$pat*p" 2>/dev/null); do
                pid=$(echo "$l" | cut -d/ -f3)
                comm=$(cat "/proc/$pid/comm" 2>/dev/null)
                case "$comm" in
                    pipewire|wireplumber|pipewire-pulse) ;;
                    *) holder="$comm" ;;
                esac
            done

            if [ -n "$holder" ]; then echo true; else echo false; fi
        `]

        stdout: StdioCollector {
            onStreamFinished: root.sinkExclusive = this.text.trim() === "true"
        }
    }

    // TODO: different services especially because of this?
    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: exclusiveCheck.running = true
    }
}
