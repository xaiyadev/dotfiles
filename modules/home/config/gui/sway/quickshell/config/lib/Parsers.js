.pragma library

// Pure parsers for the output of the tools the services call (no Quickshell dependencies),
// unit tested in tests/tst_parsers.qml.

// ---------------------------------------------------------------- audio

// "S32_LE" / "F32LE" / "S16LE" -> 32 / 32 / 16
function bitsFromFormat(format) {
    const m = /(\d+)/.exec(format || "");
    return m ? parseInt(m[1]) : 0;
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

// ---------------------------------------------------------------- display

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
