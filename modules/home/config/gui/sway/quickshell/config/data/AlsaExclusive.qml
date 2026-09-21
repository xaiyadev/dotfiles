pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire as QsPipewire
import QtQuick

// Whether some other process is currently holding the default ALSA output
Singleton {
    id: root

    readonly property QsPipewire.PwNode sink: QsPipewire.Pipewire.defaultAudioSink
    readonly property var alsaCard: sink?.properties["api.alsa.pcm.card"]

    property bool exclusive: false

    Process {
        id: exclusiveCheck

        command: [
            "sh", 
            "-c", 
            `
            card="$1"
            [ -z "$card" ] && { echo false; exit; }

            for pid in $(awk '/owner_pid/{print $3}' /proc/asound/card$card/pcm*p/sub0/status 2>/dev/null); do
                case "$(cat /proc/$pid/comm 2>/dev/null)" in
                    pipewire|wireplumber|pipewire-pulse) ;;
                    *) echo true; exit ;;
                esac
            done
            echo false
            `, 
            "_", 
            root.alsaCard !== undefined ? String(root.alsaCard) : ""
        ]

        stdout: StdioCollector {
            onStreamFinished: root.exclusive = this.text.trim() === "true"
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (root.alsaCard !== undefined) exclusiveCheck.running = true;
            else root.exclusive = false;
        }
    }
}
