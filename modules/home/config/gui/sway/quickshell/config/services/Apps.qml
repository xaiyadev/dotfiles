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
        const iconName = entry?.icon || id || fallback;
        if (!iconName) return "";

        // Absolute path or URL — use directly
        if (iconName.startsWith("/")) return "file://" + iconName;
        if (iconName.includes("://")) return iconName;

        // Use the icon if the current theme has it
        const resolved = Quickshell.iconPath(iconName, false);
        if (resolved !== "") return resolved;

        // Fall back to the Papirus icon
        return _papirus(iconName);
    }

    function trayIcon(source: string): string {
        if (!source.startsWith("image://icon/")) return source;
        const name = source.slice("image://icon/".length).replace(/\?.*$/, "");
        if (Quickshell.iconPath(name, true) !== "") return source;
        return _papirus(name);
    }

    // fallback return
    function _papirus(name: string): string {
        return "file://" + Config.fallbackIconDir + name.replace(/-symbolic$/, "") + ".svg";
    }

    // icon name or absolute path (some apps, e.g. kitty, use a file path) -> image source
    function source(icon: string, fallback: string): string {
        if (icon.startsWith("/")) return "file://" + icon;
        if (icon.includes("://")) return icon;
        return Quickshell.iconPath(icon, fallback);
    }
}
