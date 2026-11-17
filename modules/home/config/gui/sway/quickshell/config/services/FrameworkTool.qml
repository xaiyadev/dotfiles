pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import '../data'
import "../lib/Parsers.js" as Parsers

// Framework EC data via framework_tool (needs root: run with `sudo -n`, passwordless for wheel).
// Uses framework_tool from PATH, else ~/.local/state/quickshell/framework-tool (a GC root
// until it's installed system-wide). Parsing: lib/Parsers.js.
// Static data (charge limit, expansion bay, input modules, firmware) is read at startup.
Singleton {
    id: root

    property bool available: false

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
}
