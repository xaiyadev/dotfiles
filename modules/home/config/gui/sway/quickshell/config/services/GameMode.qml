pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "../lib/Parsers.js" as Parsers
import '../data'

// Game mode: on while a window is fullscreen on the *main* monitor or a Steam game runs,
// or switched by hand. Effects: notifications become compact cards in the corner (Toasts.qml),
// keep-awake is switched on (IdleInhibit), brightness / Tailscale polling pauses.
Singleton {
    id: root

    // "auto": follow fullscreen windows on the main monitor / Steam games,
    // "on" / "off": switched by hand ("off" lasts until the game / fullscreen ends)
    property string setting: "auto"

    // Main monitor per setup (kanshi profiles): Config.preferredMainMonitors, otherwise the
    // external monitor with the highest refresh rate (then the biggest, then the one closest
    // to the laptop); laptop only: the laptop panel. See Parsers.mainOutput.

    property string mainOutput: ""

    // names of the screens that currently show a fullscreen window
    readonly property list<string> fullscreenScreens: {
        const names = [];
        for (const t of ToplevelManager.toplevels.values)
            if (t?.fullscreen) for (const s of (t.screens ?? [])) if (s) names.push(s.name);
        return [...new Set(names)];
    }

    readonly property bool fullscreenOnMain: mainOutput !== "" && fullscreenScreens.includes(mainOutput)
    property bool steamGame: false

    readonly property bool autoActive: fullscreenOnMain || steamGame
    readonly property bool active: setting === "on" || (setting === "auto" && autoActive)

    function toggle(): void {
        if (active) setting = autoActive ? "off" : "auto";
        else setting = "on";
    }

    // switched off by hand during a game -> automatic again once it's over
    onAutoActiveChanged: if (!autoActive && setting === "off") setting = "auto"

    // ---- main monitor ----
    Process {
        id: outputs
        command: ["swaymsg", "-r", "-t", "get_outputs"]
        stdout: StdioCollector {
            onStreamFinished: {
                try { root.mainOutput = Parsers.mainOutput(JSON.parse(this.text), Config.preferredMainMonitors); } catch (e) { }
            }
        }
    }

    // monitors change with the kanshi profile
    Connections {
        target: Quickshell
        function onScreensChanged() { outputs.running = true; }
    }

    Component.onCompleted: {
        outputs.running = true;
        IdleInhibit.followGameMode(active);
    }

    // keep-awake follows game mode, see IdleInhibit
    onActiveChanged: IdleInhibit.followGameMode(active)

    // ---- Steam games ("reaper SteamLaunch AppId=...") ----
    Process {
        id: steamCheck
        command: ["pgrep", "-f", "SteamLaunch AppId="]
        onExited: (code) => root.steamGame = code === 0
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: steamCheck.running = true
    }

    // command line / keybinds: qs ipc call gamemode toggle | status
    IpcHandler {
        target: "gamemode"

        function toggle(): void { root.toggle(); }
        function status(): string {
            return (root.active ? "on" : "off") + " (setting: " + root.setting + ", main: " + root.mainOutput
                + ", fullscreen: [" + root.fullscreenScreens.join(", ") + "], steam game: " + root.steamGame + ")";
        }
    }
}
