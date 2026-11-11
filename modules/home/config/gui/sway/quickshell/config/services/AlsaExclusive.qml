pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire as QsPipewire
import QtQuick
import "../lib/Parsers.js" as Parsers

// Whether some other process is currently holding the default ALSA output, and which one
Singleton {
    id: root

    readonly property QsPipewire.PwNode sink: QsPipewire.Pipewire.defaultAudioSink
    readonly property var alsaCard: sink?.properties["api.alsa.pcm.card"]

    property bool exclusive: false
    // process name (/proc/<pid>/comm) of the program holding the device, "" if none
    property string owner: ""

    Process {
        id: exclusiveCheck

        command: [
            "sh", 
            "-c", 
            `
            card="$1"
            [ -z "$card" ] && { echo false; exit; }

            for tid in $(awk '/owner_pid/{print $3}' /proc/asound/card$card/pcm*p/sub0/status 2>/dev/null); do
                # owner_pid can be a thread -> use its process (thread group leader)
                pid=$(awk '/^Tgid:/{print $2}' /proc/$tid/status 2>/dev/null)
                case "$(cat /proc/$pid/comm 2>/dev/null)" in
                    pipewire|wireplumber|pipewire-pulse) ;;
                    *) echo "true $(cat /proc/$pid/comm)"; exit ;;
                esac
            done
            echo false
            `, 
            "_", 
            root.alsaCard !== undefined ? String(root.alsaCard) : ""
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const result = Parsers.parseAlsaOwner(this.text);
                root.exclusive = result.exclusive;
                root.owner = result.owner;
            }
        }
    }

    // paused in focus mode (game mode)
    Timer {
        interval: 2000
        running: !GameMode.active
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (root.alsaCard !== undefined) exclusiveCheck.running = true;
            else {
                root.exclusive = false;
                root.owner = "";
            }
        }
    }
}
