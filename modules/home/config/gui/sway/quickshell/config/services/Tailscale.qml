pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import '../data'
import "../lib/Parsers.js" as Parsers

// Tailscale status (from `tailscale status --json`)
Singleton {
    id: root

    readonly property bool active: Popups.currentKind === "network"

    property bool available: false
    property string backendState: ""
    readonly property bool running: backendState === "Running"

    property string tailnet: ""
    property string hostName: ""
    property string ip: ""
    property string exitNode: ""   // host name of the exit node in use

    // [{ name, ip, os, online, exitNodeOption, lastSeen }], online first
    property var peers: []

    function since(isoDate: string): string { return Parsers.daysAgo(isoDate, Date.now()); }

    // ---- actions ----
    readonly property string adminUrl: "https://login.tailscale.com/admin/machines"

    // last copied text, shown as "Copied" for a moment
    property string copied: ""

    function copy(text: string): void {
        Quickshell.clipboardText = text;
        copied = text;
        copiedReset.restart();
    }

    // the admin console finds a machine by its Tailscale IP
    function openInAdmin(ip: string): void {
        Qt.openUrlExternally(ip ? adminUrl + "/" + ip : adminUrl);
    }

    Timer {
        id: copiedReset
        interval: 1500
        onTriggered: root.copied = ""
    }

    function osIcon(os: string): string {
        return os === "android" || os === "iOS" ? Icons.phone : Icons.laptop;
    }

    Process {
        id: status
        command: ["tailscale", "status", "--json"]

        stdout: StdioCollector {
            onStreamFinished: {
                let data;
                try { data = JSON.parse(this.text); } catch (e) { root.available = false; return; }

                const info = Parsers.parseTailscale(data);
                root.available = true;
                root.backendState = info.backendState;
                root.tailnet = info.tailnet;
                root.hostName = info.hostName;
                root.ip = info.ip;
                root.exitNode = info.exitNode;
                root.peers = info.peers;
            }
        }
    }

    // tailscale up / down (needs the user as operator: `sudo tailscale set --operator=$USER`)
    Process {
        id: toggle
        onExited: status.running = true
    }

    function setRunning(on: bool): void {
        if (toggle.running) return;   // e.g. "tailscale up" still waiting
        toggle.command = ["tailscale", on ? "up" : "down"];
        toggle.running = true;
    }

    // always (the Wi-Fi icon shows a dot while connected), faster while the popup is open,
    // paused in game mode
    Timer {
        interval: root.active ? 3000 : 15000
        running: root.active || !GameMode.active
        repeat: true
        triggeredOnStart: true
        onTriggered: status.running = true
    }
}
