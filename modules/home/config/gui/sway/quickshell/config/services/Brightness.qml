pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import '../data'
import "../lib/Parsers.js" as Parsers

// Screen backlight via brightnessctl (works without root through logind)
Singleton {
    id: root

    property bool available: false
    property real value: 0   // 0..1

    readonly property string text: Math.round(value * 100) + "%"
    // sun with short / medium / long rays depending on the level
    readonly property string icon: Icons.brightness(value)

    // while brightnessctl is still busy, only the newest value is kept and sent afterwards
    // (dragging the slider fires many changes)
    property bool pending: false

    function set(v: real): void {
        value = Math.max(0.01, Math.min(1, v));
        if (setter.running) pending = true;
        else send();
    }

    function send(): void {
        pending = false;
        setter.command = ["brightnessctl", "-q", "set", Math.round(value * 100) + "%"];
        setter.running = true;
    }

    Process {
        id: setter
        onExited: if (root.pending) root.send()
    }

    // backlight device, found once with brightnessctl -m ("amdgpu_bl2,backlight,37316,57%,65535")
    property string device: ""

    Process {
        running: true
        command: ["brightnessctl", "-m", "--class=backlight"]
        stdout: StdioCollector {
            onStreamFinished: {
                const info = Parsers.parseBrightnessctl(this.text);
                root.available = info !== null;
                if (info) {
                    root.device = info.device;
                    root.value = info.value;
                }
            }
        }
    }

    // then read straight from sysfs (no processes); "brightness" is the value brightnessctl
    // sets (amdgpu's actual_brightness is the hardware-adjusted one and differs)
    FileView { id: current; path: root.device ? "/sys/class/backlight/" + root.device + "/brightness" : ""; blockLoading: true }
    FileView { id: maximum; path: root.device ? "/sys/class/backlight/" + root.device + "/max_brightness" : ""; blockLoading: true }

    // brightness keys change it from outside -> poll (the bar icon follows the level),
    // faster while the popup is open, paused in game mode
    Timer {
        interval: Popups.currentKind === "brightness" ? 1000 : 3000
        running: root.device !== "" && (Popups.currentKind === "brightness" || !GameMode.active)
        repeat: true
        onTriggered: {
            // a change made meanwhile is newer than what the file says
            if (setter.running || root.pending) return;
            current.reload();
            const value = Parsers.parseBacklight(current.text(), maximum.text());
            if (value !== null) root.value = value;
        }
    }
}
