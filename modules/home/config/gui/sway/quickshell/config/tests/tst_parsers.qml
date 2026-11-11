import QtQuick
import QtTest
import "../lib/Parsers.js" as P

// Unit tests for lib/Parsers.js with real tool output from the Framework 16.
// Run: tests/run.sh   (or: qmltestrunner -platform offscreen -input tests)
TestCase {
    name: "Parsers"

    // ---- audio ----
    function test_bitsFromFormat() {
        compare(P.bitsFromFormat("S32_LE"), 32);
        compare(P.bitsFromFormat("F32LE"), 32);
        compare(P.bitsFromFormat("S16LE"), 16);
        compare(P.bitsFromFormat(""), 0);
    }

    function test_hwParams() {
        const r = P.parseHwParams("access: RW_INTERLEAVED\nformat: S32_LE\nsubformat: STD\nchannels: 2\nrate: 44100 (44100/1)\nperiod_size: 2205\n");
        compare(r.bitDepth, 32);
        compare(r.sampleRate, 44100);
        compare(P.parseHwParams("closed").sampleRate, 0);
    }

    function test_soneLog() {
        const line = '[2026-11-09 18:17:55 +01:00] DEBUG [tauri_app_lib::commands::playback] src/commands/playback.rs:88: [resolve_play_uri]: track_id=199805125 — quality=Some("LOSSLESS"), bitDepth=Some(16), sampleRate=Some(44100), codec=Some("FLAC"), dash=true';
        const r = P.parseSoneLog(line);
        compare(r.bitDepth, 16);
        compare(r.sampleRate, 44100);
        compare(P.parseSoneLog(""), null);
        compare(P.parseSoneLog("bitDepth=None, sampleRate=Some(48000)").bitDepth, 0);
    }

    function test_playerStreamFormat() {
        const node = (name, state, format, rate) => ({
            type: "PipeWire:Interface:Node",
            info: { state: state, props: { "media.class": "Stream/Output/Audio", "application.name": name },
                    params: { Format: [{ format: format, rate: rate }] } }
        });
        const objects = [node("Chromium", "running", "F32LE", 48000), node("SONE", "running", "S16LE", 44100)];
        compare(P.playerStreamFormat(objects, ["sone"]).sampleRate, 44100);
        compare(P.playerStreamFormat(objects, ["spotify"]).sampleRate, 48000);   // no match: any running
        compare(P.playerStreamFormat([], ["sone"]).sampleRate, 0);
    }

    function test_formatAudio() {
        compare(P.formatAudio(16, 44100), "16-bit  ·  44.1 kHz");
        compare(P.formatAudio(24, 96000), "24-bit  ·  96 kHz");
        compare(P.formatAudio(0, 48000), "48 kHz");
        compare(P.formatAudio(16, 0), "");
    }

    function test_alsaOwner() {
        compare(P.parseAlsaOwner("true .sone-wrapped\n").owner, ".sone-wrapped");
        verify(P.parseAlsaOwner("true .sone-wrapped").exclusive);
        verify(!P.parseAlsaOwner("false\n").exclusive);
        compare(P.parseAlsaOwner("false").owner, "");
    }

    // ---- display ----
    function test_brightnessctl() {
        const b = P.parseBrightnessctl("amdgpu_bl2,backlight,37316,57%,65535\n");
        compare(b.device, "amdgpu_bl2");
        fuzzyCompare(b.value, 0.5694, 0.001);
        compare(P.parseBrightnessctl(""), null);
    }

    function test_mainOutput() {
        const out = (name, make, model, refresh, w, h, x) => ({
            name: name, make: make, model: model, active: true, rect: { x: x },
            current_mode: { width: w, height: h, refresh: refresh }
        });
        const home = [out("eDP-2", "BOE", "0x0BC9", 165000, 2560, 1600, 0),
                      out("DP-5", "AOC", "CQ32G4", 144001, 2560, 1440, 2328),
                      out("DP-10", "Acer Technologies", "RT240Y", 60000, 1920, 1080, 4888)];
        compare(P.mainOutput(home, []), "DP-5");                           // highest refresh external
        compare(P.mainOutput(home, ["RT240Y"]), "DP-10");                  // pinned
        const office = [out("eDP-2", "BOE", "x", 165000, 2560, 1600, 0),
                        out("DP-1", "iiyama", "PL2792Q", 59951, 2560, 1440, 4694),
                        out("DP-2", "iiyama", "PL2792Q", 59951, 2560, 1440, 2134)];
        compare(P.mainOutput(office, []), "DP-2");                         // same: closest to laptop
        compare(P.mainOutput([out("eDP-2", "BOE", "x", 165000, 2560, 1600, 0)], []), "eDP-2");
        compare(P.mainOutput([], []), "");
    }

    // ---- power ----
    function test_powerSysfs() {
        const r = P.parsePowerSysfs("bat 228 3117000 5491000 15480000\nport 001 0 19500000 3000000\nport 004 1 20000000 5000000\n");
        compare(r.cycles, 228);
        fuzzyCompare(r.fullWh, 48.25, 0.01);
        fuzzyCompare(r.designWh, 85.0, 0.01);
        compare(r.ports.length, 2);
        compare(r.ports[1].name, "Port 4");
        verify(r.ports[1].online);
        fuzzyCompare(r.ports[1].watts, 100, 0.001);
    }

    function test_tuned() {
        compare(P.parseTunedActive("Current active profile: fw-quiet\n"), "fw-quiet");
        compare(P.parseTunedActive(""), "");
        const d = P.parseProfileDetails("profile=fw-quiet\nboost=0\nfan=almost-silent\nprofile=fw-performance\nboost=1\nfan=performance\n");
        compare(d["fw-quiet"].boost, "0");
        compare(d["fw-performance"].fan, "performance");
    }

    function test_formatDuration() {
        compare(P.formatDuration(0), "");
        compare(P.formatDuration(300), "5 min");
        compare(P.formatDuration(11520), "3 h 12 min");
    }

    // ---- system ----
    function test_cpu() {
        const a = P.parseCpuLine("cpu  182433 2553 118926 5177982 9068 22512 41590 0 0 0");
        const b = P.parseCpuLine("cpu  182533 2553 118926 5178282 9068 22512 41590 0 0 0");
        fuzzyCompare(P.cpuUsage(a, b), 0.25, 0.0001);
        compare(P.cpuUsage(null, b), 0);
    }

    function test_fileReads() {
        const mem = P.parseMeminfo("MemTotal:       28532596 kB\nMemFree:         1234 kB\nMemAvailable:   22780432 kB\n");
        fuzzyCompare(mem.totalGiB, 27.21, 0.01);
        fuzzyCompare(mem.availableGiB, 21.72, 0.01);
        compare(P.parseMillidegrees("43000\n"), 43);
        compare(P.parseMillidegrees(""), 0);
        fuzzyCompare(P.parseBacklight("37316\n", "65535\n"), 0.5694, 0.001);
        compare(P.parseBacklight("", "65535"), null);
        compare(P.parseBacklight("5", "0"), null);
    }

    // ---- network ----
    function test_tailscale() {
        const r = P.parseTailscale({
            BackendState: "Running",
            CurrentTailnet: { Name: "xaiyadev.github" },
            Self: { HostName: "pineapple", TailscaleIPs: ["100.107.68.43", "fd7a::1"] },
            Peer: {
                a: { HostName: "strawberry", TailscaleIPs: ["100.119.87.112"], OS: "android", Online: false, ExitNode: false, ExitNodeOption: false, LastSeen: "2026-11-04T00:02:43Z" },
                b: { HostName: "apricot", TailscaleIPs: ["100.111.243.3"], OS: "linux", Online: true, ExitNode: true, ExitNodeOption: true, LastSeen: "0001-01-01T00:00:00Z" }
            }
        });
        compare(r.tailnet, "xaiyadev.github");
        compare(r.ip, "100.107.68.43");
        compare(r.exitNode, "apricot");
        compare(r.peers[0].name, "apricot");   // online first
        compare(P.parseTailscale({}).peers.length, 0);
    }

    function test_daysAgo() {
        const now = new Date("2026-11-11T12:00:00Z").getTime();
        compare(P.daysAgo("2026-11-11T08:00:00Z", now), "today");
        compare(P.daysAgo("2026-11-10T08:00:00Z", now), "1 day ago");
        compare(P.daysAgo("2026-11-04T00:02:43Z", now), "7 days ago");
    }

    // ---- framework_tool ----
    readonly property string frameworkOutput: "@@ --privacy\nPrivacy Slider (Black = Device Connected; Red = Device Disconnected)\n  Microphone:  Connected\n  Camera:      Disconnected\n@@ --thermal\n  ambient_f75303@4d:  41 C\n  apu_f75303@4d:      41 C\n  cpu@4c:             43 C\n  gpu_vr_f75303@4d:   0 C\n  gpu_temp@40:        NotPowered\n  Left Fan:           1531 RPM\n  Right Fan:          1524 RPM\n  AP Throttle Status\n    Soft (AMD SPPT):  false\n    Hard (PROCHOT#):  true\n@@ --charge-limit\nMinimum 0%, Maximum 80%\n@@ --expansion-bay\nExpansion Bay\n  Enabled:       true\n  No fault:      true\n  Door closed:   true\n  Vendor:        GpuAmdR23M\n@@ --inputdeck\nChassis Closed:   true\nPositions:\n  Pos 0: GenericC\n  Pos 1: KeyboardA\n  Pos 2: Disconnected\n@@ --versions\nTool Version:     0.6.6\nUEFI BIOS\n  Version:        04.05\n  Release Date:   06/30/2026\nEC Firmware\n  Build version:  lotus-4.0.5-2246d58 2026-06-26 03:39:05 lotus@ip\n  Current image:  RO\nPD Controllers\n  Right (01):       0.0.21 (MainFw)\n  Left  (23):       0.0.21 (MainFw)\nTouchpad\n  Firmware Version: v0905\n"

    function test_framework() {
        const s = P.frameworkSections(frameworkOutput);
        compare(Object.keys(s).length, 6);

        const privacy = P.parseFrameworkPrivacy(s["--privacy"]);
        verify(privacy.micOn);
        verify(!privacy.cameraOn);

        const thermal = P.parseFrameworkThermal(s["--thermal"]);
        compare(thermal.leftFanRpm, 1531);
        compare(thermal.rightFanRpm, 1524);
        verify(!thermal.softThrottle);
        verify(thermal.hardThrottle);
        compare(thermal.temperatures.length, 3);       // 0 C and NotPowered left out
        compare(thermal.temperatures[0].name, "ambient");

        compare(P.parseChargeLimit(s["--charge-limit"]), 80);
        compare(P.parseKeyValues(s["--expansion-bay"]).Vendor, "GpuAmdR23M");
        compare(P.parseInputDeck(s["--inputdeck"]), ["GenericC", "KeyboardA", "Disconnected"]);

        const fw = P.parseFirmware(s["--versions"]);
        compare(fw[0].name, "BIOS");
        compare(fw[0].version, "04.05");
        compare(fw[1].version, "lotus-4.0.5-2246d58");
        compare(fw[2].name, "PD right");
        compare(fw[4].name, "Touchpad");
    }
}
