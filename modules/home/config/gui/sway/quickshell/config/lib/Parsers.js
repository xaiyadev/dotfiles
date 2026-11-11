.pragma library

// Pure parsers for the output of the tools the services call (no Quickshell dependencies),
// unit tested in tests/tst_parsers.qml.

// ---------------------------------------------------------------- audio

// "S32_LE" / "F32LE" / "S16LE" -> 32 / 32 / 16
function bitsFromFormat(format) {
    const m = /(\d+)/.exec(format || "");
    return m ? parseInt(m[1]) : 0;
}

// /proc/asound/cardN/pcmXp/sub0/hw_params -> { bitDepth, sampleRate }
function parseHwParams(text) {
    const format = /format:\s*(\S+)/.exec(text);
    const rate = /rate:\s*(\d+)/.exec(text);
    return { bitDepth: format ? bitsFromFormat(format[1]) : 0, sampleRate: rate ? parseInt(rate[1]) : 0 };
}

// SONE log line "[resolve_play_uri]: ... bitDepth=Some(16), sampleRate=Some(44100) ..." -> { bitDepth, sampleRate } | null
function parseSoneLog(text) {
    const bits = /bitDepth=Some\((\d+)\)/.exec(text);
    const rate = /sampleRate=Some\((\d+)\)/.exec(text);
    if (!rate) return null;
    return { bitDepth: bits ? parseInt(bits[1]) : 0, sampleRate: parseInt(rate[1]) };
}

// pw-dump objects -> negotiated format of the player's output stream
// (running stream matching one of `names` first, then any matching, then any running one)
function playerStreamFormat(objects, names) {
    const streams = objects.filter(o =>
        o.type === "PipeWire:Interface:Node"
        && o.info && o.info.props && o.info.props["media.class"] === "Stream/Output/Audio"
        && o.info.params && o.info.params.Format && o.info.params.Format.length > 0);

    const matches = s => {
        const p = s.info.props;
        const app = [p["application.name"], p["application.process.binary"], p["node.name"]]
            .filter(n => n).join(" ").toLowerCase();
        return names.some(n => app.includes(n));
    };

    const running = streams.filter(s => s.info.state === "running");
    const stream = running.find(matches) || streams.find(matches) || running[0];
    const format = stream ? stream.info.params.Format[0] : null;
    return { bitDepth: format ? bitsFromFormat(format.format) : 0, sampleRate: format ? (format.rate || 0) : 0 };
}

// 16, 44100 -> "16-bit  ·  44.1 kHz"
function formatAudio(bitDepth, sampleRate) {
    if (sampleRate <= 0) return "";
    const khz = (sampleRate / 1000).toFixed(sampleRate % 1000 === 0 ? 0 : 1) + " kHz";
    return bitDepth > 0 ? bitDepth + "-bit  ·  " + khz : khz;
}

// "true .sone-wrapped" / "false" -> { exclusive, owner }
function parseAlsaOwner(text) {
    const parts = text.trim().split(" ");
    const exclusive = parts[0] === "true";
    return { exclusive: exclusive, owner: exclusive ? parts.slice(1).join(" ") : "" };
}

// ---------------------------------------------------------------- display

// brightnessctl -m: "amdgpu_bl2,backlight,37316,57%,65535" -> { device: "amdgpu_bl2", value: 0.569 } | null
function parseBrightnessctl(text) {
    const f = text.trim().split(",");
    if (f.length < 5) return null;
    const value = parseBacklight(f[2], f[4]);
    return value === null ? null : { device: f[0], value: value };
}

// swaymsg -r -t get_outputs -> name of the main monitor: a `preferred` one ("<make> <model>"
// contains it), else the external output with the highest refresh rate (then biggest, then
// leftmost), else the first active one (laptop panel)
function mainOutput(outputs, preferred) {
    const active = outputs.filter(o => o.active);
    const external = active.filter(o => !o.name.startsWith("eDP"));
    const pinned = external.find(o => preferred.some(p => (o.make + " " + o.model).includes(p)));
    const area = o => o.current_mode.width * o.current_mode.height;
    const best = external.slice().sort((a, b) =>
        (b.current_mode.refresh - a.current_mode.refresh) || (area(b) - area(a)) || (a.rect.x - b.rect.x))[0];
    const main = pinned || best || active[0];
    return main ? main.name : "";
}

// ---------------------------------------------------------------- power

// lines "bat <cycles> <charge_full µAh> <charge_full_design µAh> <voltage_min_design µV>" and
// "port <n> <online> <voltage_max µV> <current_max µA>"
function parsePowerSysfs(text) {
    const result = { cycles: 0, fullWh: 0, designWh: 0, ports: [] };
    for (const line of text.split("\n")) {
        const f = line.trim().split(/\s+/);
        if (f[0] === "bat") {
            result.cycles = parseInt(f[1]);
            result.fullWh = parseInt(f[2]) * parseInt(f[4]) / 1e12;
            result.designWh = parseInt(f[3]) * parseInt(f[4]) / 1e12;
        } else if (f[0] === "port") {
            const volts = parseInt(f[3]) / 1e6;
            const amps = parseInt(f[4]) / 1e6;
            result.ports.push({ name: "Port " + parseInt(f[1]), online: f[2] === "1", volts: volts, amps: amps, watts: volts * amps });
        }
    }
    return result;
}

// "Current active profile: fw-quiet" -> "fw-quiet"
function parseTunedActive(text) {
    const m = /:\s*(\S+)/.exec(text);
    return m ? m[1] : "";
}

// "profile=fw-quiet\nboost=0\nfan=almost-silent\n..." -> { "fw-quiet": { boost: "0", fan: "almost-silent" } }
function parseProfileDetails(text) {
    const details = {};
    let current = null;
    for (const line of text.split("\n")) {
        const i = line.indexOf("=");
        if (i < 0) continue;
        const key = line.slice(0, i), value = line.slice(i + 1);
        if (key === "profile") current = details[value] = {};
        else if (current) current[key] = value;
    }
    return details;
}

// 11520 -> "3 h 12 min", 300 -> "5 min", 0 -> ""
function formatDuration(seconds) {
    if (seconds <= 0) return "";
    const h = Math.floor(seconds / 3600);
    const m = Math.round((seconds % 3600) / 60);
    return h > 0 ? h + " h " + m + " min" : m + " min";
}

// ---------------------------------------------------------------- system

// "cpu  user nice system idle iowait irq softirq steal ..." -> { idle, total }
function parseCpuLine(line) {
    const v = line.trim().split(/\s+/).slice(1, 9).map(Number);
    return { idle: v[3] + v[4], total: v.reduce((a, b) => a + b, 0) };
}

// usage between two parseCpuLine samples, 0..1
function cpuUsage(previous, current) {
    if (!previous) return 0;
    const dt = current.total - previous.total;
    return dt > 0 ? 1 - (current.idle - previous.idle) / dt : 0;
}

// ---------------------------------------------------------------- network

// tailscale status --json -> what the bar shows
function parseTailscale(data) {
    const peers = Object.keys(data.Peer || {}).map(k => data.Peer[k]);
    const exit = peers.find(p => p.ExitNode);
    return {
        backendState: data.BackendState || "",
        tailnet: data.CurrentTailnet ? data.CurrentTailnet.Name : "",
        hostName: data.Self ? data.Self.HostName : "",
        ip: data.Self && data.Self.TailscaleIPs ? data.Self.TailscaleIPs[0] : "",
        exitNode: exit ? exit.HostName : "",
        peers: peers.map(p => ({
            name: p.HostName,
            ip: p.TailscaleIPs ? p.TailscaleIPs[0] : "",
            os: p.OS,
            online: p.Online,
            exitNodeOption: p.ExitNodeOption,
            lastSeen: p.LastSeen
        })).sort((a, b) => (b.online - a.online) || a.name.localeCompare(b.name))
    };
}

// ISO date -> "today" / "1 day ago" / "7 days ago"
function daysAgo(isoDate, now) {
    const days = Math.floor((now - new Date(isoDate).getTime()) / 86400000);
    if (days < 1) return "today";
    return days === 1 ? "1 day ago" : days + " days ago";
}

// ---------------------------------------------------------------- framework_tool

// "@@ --option" separated output -> { "--option": [non-empty lines] }
function frameworkSections(text) {
    const out = {};
    let current = null;
    for (const line of text.split("\n")) {
        if (line.startsWith("@@ ")) current = out[line.slice(3)] = [];
        else if (current && line.trim() !== "") current.push(line);
    }
    return out;
}

function afterColon(line) { return line.slice(line.indexOf(":") + 1).trim(); }

// --privacy -> { micOn, cameraOn } (on = device connected, switch open)
function parseFrameworkPrivacy(lines) {
    const result = { micOn: true, cameraOn: true };
    for (const line of lines) {
        if (line.includes("Microphone:")) result.micOn = afterColon(line) === "Connected";
        if (line.includes("Camera:")) result.cameraOn = afterColon(line) === "Connected";
    }
    return result;
}

// --thermal -> { leftFanRpm, rightFanRpm, softThrottle, hardThrottle, temperatures: [{ name, celsius }] }
function parseFrameworkThermal(lines) {
    const result = { leftFanRpm: 0, rightFanRpm: 0, softThrottle: false, hardThrottle: false, temperatures: [] };
    for (const line of lines) {
        const v = afterColon(line);
        if (line.includes("Left Fan:")) result.leftFanRpm = parseInt(v);
        else if (line.includes("Right Fan:")) result.rightFanRpm = parseInt(v);
        else if (line.includes("Soft (")) result.softThrottle = v === "true";
        else if (line.includes("Hard (")) result.hardThrottle = v === "true";
        else if (/^\s+\S+@\S+:\s+-?\d+ C$/.test(line)) {
            const celsius = parseInt(v);
            if (celsius > 0) result.temperatures.push({ name: line.trim().split(":")[0].replace(/(_f75303)?@.*$/, ""), celsius: celsius });
        }
    }
    return result;
}

// --charge-limit "Minimum 0%, Maximum 80%" -> 80
function parseChargeLimit(lines) {
    const m = /Maximum (\d+)%/.exec(lines.join(" "));
    return m ? parseInt(m[1]) : 0;
}

// "Key: value" lines -> { Key: value } (e.g. --expansion-bay)
function parseKeyValues(lines) {
    const out = {};
    for (const line of lines)
        if (line.includes(":")) out[line.trim().split(":")[0]] = afterColon(line);
    return out;
}

// --inputdeck "Pos 1: KeyboardA" lines -> ["GenericC", "KeyboardA", ...]
function parseInputDeck(lines) {
    return lines.filter(l => /Pos \d+:/.test(l)).map(afterColon);
}

// --versions -> [{ name, version }] for BIOS, EC, PD controllers and devices with firmware
function parseFirmware(lines) {
    const fw = [];
    let heading = "";
    for (const line of lines) {
        if (!line.startsWith(" ")) { heading = line.trim(); continue; }
        const key = line.trim().split(":")[0];
        const v = afterColon(line);
        if (heading === "UEFI BIOS" && key === "Version") fw.push({ name: "BIOS", version: v });
        else if (heading === "EC Firmware" && key === "Build version") fw.push({ name: "EC", version: v.split(" ")[0] });
        else if (heading === "PD Controllers") fw.push({ name: "PD " + key.split(" ")[0].toLowerCase(), version: v.split(" ")[0] });
        else if (key === "Firmware Version" || key === "Active Firmware") fw.push({ name: heading, version: v.split(" ")[0] });
    }
    return fw;
}

// ---------------------------------------------------------------- read with FileView

// /proc/meminfo -> { totalGiB, availableGiB }
function parseMeminfo(text) {
    const kib = key => {
        const m = new RegExp("^" + key + ":\\s+(\\d+)", "m").exec(text);
        return m ? parseInt(m[1]) : 0;
    };
    return { totalGiB: kib("MemTotal") / 1048576, availableGiB: kib("MemAvailable") / 1048576 };
}

// hwmon temp*_input "43000\n" -> 43 (°C), "" -> 0
function parseMillidegrees(text) {
    const v = parseInt(text);
    return isNaN(v) ? 0 : v / 1000;
}

// /sys/class/backlight/<dev>/brightness + max_brightness -> 0..1 | null
function parseBacklight(brightness, max) {
    const b = parseInt(brightness), m = parseInt(max);
    return m > 0 && !isNaN(b) ? b / m : null;
}
