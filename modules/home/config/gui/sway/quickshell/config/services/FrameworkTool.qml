pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import '../data'
import "../lib/Parsers.js" as Parsers

// Framework EC data via framework_tool (needs root: run with `sudo -n`, passwordless for wheel).
// Uses framework_tool from PATH, else ~/.local/state/quickshell/framework-tool (a GC root
// until it's installed system-wide). Parsing: lib/Parsers.js.
// Live (privacy switches, EC temperatures, fans, throttling): while a hub tab that shows them is
//   open (`liveWanted`, set by FrameworkHub), or the privacy switches only while the mic /
//   camera is in use (the bar dot ignores devices whose switch is off).
// Static (charge limit, expansion bay, input modules, firmware): at startup, retried on demand.
Singleton {
    id: root

    property bool liveWanted: false
    property bool available: false

    // privacy sliders: true = device connected (switch open)
    property bool micSwitchOn: true
    property bool cameraSwitchOn: true

    // EC sensors
    property int leftFanRpm: 0
    property int rightFanRpm: 0
    property var temperatures: []      // [{ name, celsius }]
    property bool softThrottle: false
    property bool hardThrottle: false

    // static
    property int chargeLimit: 0
    property var expansionBay: ({})    // { Enabled, "No fault", "Door closed", Board, Vendor, ... }
    property var inputDeck: []         // ["KeyboardA", "GenericC", ...] by position
    property var firmware: []          // [{ name, version }]
    property bool staticLoaded: false

    // known expansion bay modules
    readonly property var bayNames: ({
        "GpuAmdR23M": "AMD Radeon RX 7700S",
        "GpuNvidiaAd107": "NVIDIA GeForce RTX 5070"
    })
    readonly property string bayModule: bayNames[expansionBay.Vendor] ?? expansionBay.Vendor ?? ""

    function run(process, options): void {
        if (process.running) return;
        process.command = ["sh", "-c", `
            ft=$(command -v framework_tool || echo "$HOME/.local/state/quickshell/framework-tool/bin/framework_tool")
            [ -x "$ft" ] || exit 3
            for o in "$@"; do echo "@@ $o"; sudo -n "$ft" "$o" 2>/dev/null; done
        `, "_", ...options];
        process.running = true;
    }

    // sections that actually returned something (sudo / framework_tool may fail)
    function sectionsOf(text: string): var {
        const s = Parsers.frameworkSections(text);
        if (Object.keys(s).some(key => s[key].length > 0)) available = true;
        return s;
    }

    Process {
        id: live
        stdout: StdioCollector {
            onStreamFinished: {
                const s = root.sectionsOf(this.text);
                if (s["--privacy"]?.length) {
                    const privacy = Parsers.parseFrameworkPrivacy(s["--privacy"]);
                    root.micSwitchOn = privacy.micOn;
                    root.cameraSwitchOn = privacy.cameraOn;
                }
                if (s["--thermal"]?.length) {
                    const thermal = Parsers.parseFrameworkThermal(s["--thermal"]);
                    root.leftFanRpm = thermal.leftFanRpm;
                    root.rightFanRpm = thermal.rightFanRpm;
                    root.softThrottle = thermal.softThrottle;
                    root.hardThrottle = thermal.hardThrottle;
                    root.temperatures = thermal.temperatures;
                }
            }
        }
    }

    Process {
        id: staticInfo
        stdout: StdioCollector {
            onStreamFinished: {
                const s = root.sectionsOf(this.text);
                if (!s["--versions"]?.length) return;   // failed: retried when the hub opens
                root.chargeLimit = Parsers.parseChargeLimit(s["--charge-limit"] ?? []);
                root.expansionBay = Parsers.parseKeyValues(s["--expansion-bay"] ?? []);
                root.inputDeck = Parsers.parseInputDeck(s["--inputdeck"] ?? []);
                root.firmware = Parsers.parseFirmware(s["--versions"]);
                root.staticLoaded = true;
            }
        }
    }

    function loadStatic(): void { run(staticInfo, ["--charge-limit", "--expansion-bay", "--inputdeck", "--versions"]); }

    Component.onCompleted: loadStatic()

    Timer {
        interval: 3000
        running: root.liveWanted
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.run(live, ["--privacy", "--thermal"]);
            if (!root.staticLoaded) root.loadStatic();
        }
    }

    // hub closed / other tab, but mic or camera in use: keep the switch positions current
    Timer {
        interval: 5000
        running: !root.liveWanted && Privacy.active
        repeat: true
        triggeredOnStart: true
        onTriggered: root.run(live, ["--privacy"])
    }
}
