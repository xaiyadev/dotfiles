pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import '../data'
import "../lib/Parsers.js" as Parsers

// CPU load, memory and temperatures for the Framework hub (System tab), read straight from
// /proc and the hwmon files (FileView, no processes) while the hub is open.
// The hwmon files are found once at startup (their numbers change between boots).
// The dGPU temperature is only read while the dGPU is awake (reading it would wake it up).
Singleton {
    id: root

    readonly property bool active: Popups.currentKind === "framework"

    property real cpuUsage: 0      // 0..1
    property real memUsedGiB: 0
    property real memTotalGiB: 0
    property real cpuTemp: 0
    property real igpuTemp: 0
    property real dgpuTemp: 0
    property bool dgpuAwake: false
    property real nvmeTemp: 0

    // previous /proc/stat sample for the CPU delta
    property var lastCpu: null

    // hwmon temperature files, found once
    property var paths: ({})

    Process {
        id: discover
        running: true
        command: ["sh", "-c", `
            for h in /sys/class/hwmon/hwmon*; do
                case "$(cat "$h/name")" in
                    k10temp) echo "cpu $h/temp1_input" ;;
                    nvme) echo "nvme $h/temp1_input" ;;
                    amdgpu)
                        dev=$(readlink -f "$h/device")
                        if [ "$(cat "$dev/boot_vga" 2>/dev/null)" = 1 ]; then echo "igpu $h/temp1_input"
                        else echo "dgpu $h/temp1_input"; echo "dgpuStatus $dev/power/runtime_status"; fi ;;
                esac
            done
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                const paths = {};
                for (const line of this.text.split("\n")) {
                    const [key, path] = line.split(" ");
                    if (key && path) paths[key] = path;
                }
                root.paths = paths;
            }
        }
    }

    FileView { id: stat; path: "/proc/stat"; blockLoading: true }
    FileView { id: meminfo; path: "/proc/meminfo"; blockLoading: true }
    FileView { id: cpuFile; path: root.paths.cpu ?? ""; blockLoading: true }
    FileView { id: nvmeFile; path: root.paths.nvme ?? ""; blockLoading: true }
    FileView { id: igpuFile; path: root.paths.igpu ?? ""; blockLoading: true }
    // not read at startup: only while the dGPU is awake
    FileView { id: dgpuFile; path: root.paths.dgpu ?? ""; blockLoading: true; preload: false }
    FileView { id: dgpuStatus; path: root.paths.dgpuStatus ?? ""; blockLoading: true }

    function sample(): void {
        stat.reload();
        const cpu = Parsers.parseCpuLine(stat.text().split("\n")[0]);
        cpuUsage = Parsers.cpuUsage(lastCpu, cpu);
        lastCpu = cpu;

        meminfo.reload();
        const mem = Parsers.parseMeminfo(meminfo.text());
        memTotalGiB = mem.totalGiB;
        memUsedGiB = mem.totalGiB - mem.availableGiB;

        for (const file of [cpuFile, nvmeFile, igpuFile, dgpuStatus]) if (file.path !== "") file.reload();
        cpuTemp = Parsers.parseMillidegrees(cpuFile.text());
        nvmeTemp = Parsers.parseMillidegrees(nvmeFile.text());
        igpuTemp = Parsers.parseMillidegrees(igpuFile.text());

        dgpuAwake = dgpuStatus.text().trim() === "active";
        if (dgpuAwake) dgpuFile.reload();
        dgpuTemp = dgpuAwake ? Parsers.parseMillidegrees(dgpuFile.text()) : 0;
    }

    Timer {
        interval: 2000
        running: root.active
        repeat: true
        triggeredOnStart: true
        onTriggered: root.sample()
    }
}
