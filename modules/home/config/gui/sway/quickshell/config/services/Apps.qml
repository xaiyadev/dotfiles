pragma Singleton

import Quickshell
import QtQuick

import '../data'

// Resolve an application's icon from its desktop entry.
// Tries the id, then Quickshell's heuristic (name / StartupWMClass), then the display name.
Singleton {
    function entryFor(id: string, name: string): var {
        DesktopEntries.applications.values; // re-evaluate bindings once desktop entries have loaded
        return (id ? DesktopEntries.byId(id) : null)
            ?? (id ? DesktopEntries.heuristicLookup(id) : null)
            ?? (name ? DesktopEntries.heuristicLookup(name) : null)
            ?? (name ? DesktopEntries.applications.values.find(e => e.name.toLowerCase() === name.toLowerCase()) : null)
            ?? null;
    }

    function iconPath(id: string, name: string, fallback: string): string {
        const entry = entryFor(id, name);
        return source(entry?.icon || id || fallback, fallback);
    }

    // Tray icons are "image://icon/<name>" requests; if the icon theme doesn't have <name>
    // (e.g. EasyEffects ships its icon only in its own package) Quickshell would draw a
    // placeholder, so use the Papirus version of the app icon instead.
    function trayIcon(source: string): string {
        if (!source.startsWith("image://icon/")) return source;
        const name = source.slice("image://icon/".length).replace(/\?.*$/, "");
        if (Quickshell.iconPath(name, true) !== "") return source;
        return "file://" + Config.fallbackIconDir + name.replace(/-symbolic$/, "") + ".svg";
    }

    // icon name or absolute path (some apps, e.g. kitty, use a file path) -> image source
    function source(icon: string, fallback: string): string {
        if (icon.startsWith("/")) return "file://" + icon;
        if (icon.includes("://")) return icon;
        return Quickshell.iconPath(icon, fallback);
    }
}
