pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

import '../data'
import "../lib/Parsers.js" as Parsers

// Battery (UPower), plus Framework details from sysfs / fw-fanctrl:
// battery wear, USB-C power delivery per port and the fan.
Singleton {
    id: root

    // Charge limit (read from the EC, 80 until known): this charge counts as 100% (like waybar's full-at)
    readonly property int fullAt: FrameworkTool.chargeLimit > 0 ? FrameworkTool.chargeLimit : 80

    readonly property var device: UPower.devices.values.find(d => d.isLaptopBattery) ?? UPower.displayDevice
    readonly property bool present: device?.isPresent ?? false

    readonly property real rawPercent: (device?.percentage ?? 0) * 100
    readonly property int percent: Math.min(100, Math.round(rawPercent / fullAt * 100))

    readonly property bool onBattery: UPower.onBattery
    readonly property bool charging: device?.state === UPowerDeviceState.Charging

    readonly property real watts: Math.abs(device?.changeRate ?? 0)
    readonly property int secondsLeft: charging ? (device?.timeToFull ?? 0) : onBattery ? (device?.timeToEmpty ?? 0) : 0

    readonly property string level: percent <= 20 ? "critical" : percent <= 30 ? "warning" : "normal"
    readonly property color levelColor: level === "critical" ? Theme.red : level === "warning" ? Theme.rosewater : Theme.text

    // plugged in and at the charge limit
    readonly property bool full: !onBattery && !charging && percent >= 99

    // bar: battery + percentage; when full only the plug
    readonly property string barText: full ? "" : percent + "%"

    readonly property string statusText: {
        if (charging) return "Charging";
        if (onBattery) return "Discharging";
        return rawPercent >= fullAt - 1 ? "Plugged in (charge limit)" : "Plugged in, not charging";
    }

    function formatDuration(seconds: int): string { return Parsers.formatDuration(seconds); }

    // ---- Framework details ----
    readonly property bool active: Popups.currentKind === "framework"

    property int cycles: 0
    property real fullWh: 0
    property real designWh: 0
    readonly property real health: designWh > 0 ? fullWh / designWh * 100 : 0

    // USB-C ports: [{ name, online, volts, amps, watts }]
    property var ports: []

    // fan (fw-fanctrl)
    property bool fanAvailable: false
    property int fanSpeed: 0
    property real temperature: 0
    property string fanStrategy: ""

    Process {
        id: sysfs
        command: ["sh", "-c", `
            for b in /sys/class/power_supply/BAT*; do
                v=$(cat "$b/voltage_min_design")
                echo "bat $(cat "$b/cycle_count") $(cat "$b/charge_full") $(cat "$b/charge_full_design") $v"
                break
            done
            for p in /sys/class/power_supply/ucsi-source-psy-*; do
                echo "port \${p##*:} $(cat "$p/online") $(cat "$p/voltage_max") $(cat "$p/current_max")"
            done
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                const result = Parsers.parsePowerSysfs(this.text);
                root.cycles = result.cycles;
                root.fullWh = result.fullWh;
                root.designWh = result.designWh;
                root.ports = result.ports;
            }
        }
    }

    Process {
        id: fan
        command: ["fw-fanctrl", "--output-format", "JSON", "print"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text);
                    root.fanSpeed = data.speed;
                    root.temperature = data.temperature;
                    root.fanStrategy = data.strategy;
                    root.fanAvailable = data.status === "success";
                } catch (e) {
                    root.fanAvailable = false;
                }
            }
        }
    }

    // ---- power profile (tuned, the same profiles as the Super+F12 toggle) ----
    readonly property var profiles: [
        { id: "fw-quiet", label: "Quiet", icon: "power-profile-power-saver-symbolic" },
        { id: "fw-performance", label: "Performance", icon: "power-profile-performance-symbolic" }
    ]
    property string profile: ""

    function setProfile(id: string): void {
        profile = id;
        profileSetter.command = ["tuned-adm", "profile", id];
        profileSetter.running = true;
    }

    Process {
        id: profileSetter
        onExited: profileReader.running = true
    }

    // "Current active profile: fw-quiet"
    Process {
        id: profileReader
        command: ["tuned-adm", "active"]
        stdout: StdioCollector {
            onStreamFinished: root.profile = Parsers.parseTunedActive(this.text)
        }
    }

    // what each profile changes: CPU boost from its tuned.conf, fan strategy from its script
    // { "fw-quiet": { boost: "0", fan: "almost-silent" }, ... }
    property var profileDetails: ({})

    Process {
        id: profileInfo
        command: ["sh", "-c", `
            for p in "$@"; do
                c=/etc/tuned/profiles/$p/tuned.conf
                [ -f "$c" ] || continue
                echo "profile=$p"
                grep -E '^boost=' "$c"
                s=$(sed -n 's/^script=//p' "$c")
                [ -n "$s" ] && grep -o 'fw-fanctrl use [a-z-]*' "$s" | sed 's/^fw-fanctrl use /fan=/'
            done
        `, "_", ...root.profiles.map(p => p.id)]
        stdout: StdioCollector {
            onStreamFinished: root.profileDetails = Parsers.parseProfileDetails(this.text)
        }
    }

    // read when the popup opens (it can also change via Super+F12)
    onActiveChanged: if (active) {
        profileReader.running = true;
        profileInfo.running = true;
    }

    // only while the popup is open
    Timer {
        interval: 2000
        running: root.active
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            sysfs.running = true;
            fan.running = true;
        }
    }
}
