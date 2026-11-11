pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import '../data'
import "../lib/Parsers.js" as Parsers

// Bit depth / sample rate of what is currently playing.
// Exclusive mode: read the real hardware params from /proc/asound.
// Shared mode:    read the negotiated format of the player's PipeWire stream.
Singleton {
    id: root

    // only poll while the audio popup is open
    readonly property bool active: Popups.currentKind === "audio"

    property int bitDepth: 0
    property int sampleRate: 0

    readonly property string text: Parsers.formatAudio(bitDepth, sampleRate)

    // the source asked last ("sone" / "alsa" / "pipewire"); results from others arrive late
    // and are dropped (e.g. a PipeWire result must not overwrite the real SONE format)
    property string source: ""

    // no stale value from the last time when the popup opens again
    onActiveChanged: if (active) {
        bitDepth = 0;
        sampleRate = 0;
    }

    function apply(from: string, format): void {
        if (from !== source) return;
        bitDepth = format.bitDepth;
        sampleRate = format.sampleRate;
    }

    Process {
        id: hwParams

        command: [
            "sh", "-c",
            `for f in /proc/asound/card"$1"/pcm*p/sub0/hw_params; do
                 grep -q '^format' "$f" 2>/dev/null && { cat "$f"; exit; }
             done`,
            "_",
            AlsaExclusive.alsaCard !== undefined ? String(AlsaExclusive.alsaCard) : ""
        ]

        stdout: StdioCollector {
            onStreamFinished: root.apply("alsa", Parsers.parseHwParams(this.text))
        }
    }

    Process {
        id: pwDump

        command: ["pw-dump"]

        stdout: StdioCollector {
            onStreamFinished: {
                let objects;
                try { objects = JSON.parse(this.text); } catch (e) { return; }

                const player = Mpris.selectedPlayer;
                const names = [player?.identity, player?.desktopEntry]
                    .filter(n => n).map(n => n.toLowerCase());

                root.apply("pipewire", Parsers.playerStreamFormat(objects, names));
            }
        }
    }

    // SONE: the ALSA/PipeWire format is only the container the DAC gets (e.g. 16-bit padded
    // to S32), so read the real source format SONE logs when it resolves a track:
    // "[resolve_play_uri]: track_id=123 — quality=Some("LOSSLESS"), bitDepth=Some(16), sampleRate=Some(44100), ..."
    readonly property bool isSone: (Mpris.selectedPlayer?.desktopEntry ?? "").toLowerCase().includes("sone")
    readonly property string soneTrackId: {
        const url = Mpris.selectedPlayer?.metadata?.["xesam:url"] ?? "";
        const m = /tidal:\/\/track\/(\d+)/.exec(url);
        return m ? m[1] : "";
    }
    onSoneTrackIdChanged: if (active) refresh()

    Process {
        id: soneLog

        command: [
            "sh", "-c",
            `grep -a "resolve_play_uri.*track_id=$1[^0-9]" "$HOME/.config/sone/logs/sone_rCURRENT.log" 2>/dev/null | tail -n 1`,
            "_",
            root.soneTrackId
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const format = Parsers.parseSoneLog(this.text);
                if (format) root.apply("sone", format);
                else root.refreshFromOutput(); // no log entry (yet) -> fall back
            }
        }
    }

    function refreshFromOutput(): void {
        source = AlsaExclusive.exclusive ? "alsa" : "pipewire";
        if (source === "alsa") hwParams.running = true;
        else pwDump.running = true;
    }

    function refresh(): void {
        if (isSone && soneTrackId !== "") {
            source = "sone";
            soneLog.running = true;
        }
        else refreshFromOutput();
    }

    Timer {
        interval: 2000
        running: root.active
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    Connections {
        target: AlsaExclusive
        function onExclusiveChanged() { if (root.active) root.refresh(); }
    }
}
