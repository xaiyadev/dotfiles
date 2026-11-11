pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Microphone / camera in use (shown in the Framework hub: dot on its icon + Privacy tab)
Singleton {
    id: root

    readonly property list<string> micApps: [...new Set(Pipewire.recordingStreams.map(n => Pipewire.streamAppName(n)))]
    property list<string> cameraApps: []
    // false when no camera exists, e.g. the Framework camera privacy switch is set to off
    property bool cameraPresent: false

    readonly property bool micActive: micApps.length > 0
    readonly property bool cameraActive: cameraApps.length > 0
    readonly property bool active: micActive || cameraActive

    // processes holding a /dev/video* device (only checked if a camera exists,
    // the Framework privacy switch removes it completely)
    Process {
        id: cameraCheck
        command: ["sh", "-c", `
            ls /dev/video* >/dev/null 2>&1 || exit 0
            echo "#present"
            find /proc/[0-9]*/fd -maxdepth 1 -lname '/dev/video*' 2>/dev/null \
                | cut -d/ -f3 | sort -u | while read -r pid; do cat "/proc/$pid/comm"; done | sort -u
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.split("\n").filter(l => l !== "");
                root.cameraPresent = lines.includes("#present");
                root.cameraApps = lines.filter(l => l !== "#present");
            }
        }
    }

    // paused in focus mode (game mode); the mic part comes from PipeWire and keeps working
    Timer {
        interval: 3000
        running: !GameMode.active
        repeat: true
        triggeredOnStart: true
        onTriggered: cameraCheck.running = true
    }
}
