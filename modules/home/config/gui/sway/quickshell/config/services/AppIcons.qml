pragma Singleton

import Quickshell
import QtQuick

// get an app icon if needed
Singleton {
    // find the desktop entry by id or display name and use its icon, else the fallback icon
    function iconPath(id: string, name: string, fallback: string): string {
        const apps = DesktopEntries.applications.values; // also makes bindings update once the entries are loaded
        const entry = (id ? DesktopEntries.heuristicLookup(id) : null)
            ?? (name ? DesktopEntries.heuristicLookup(name) : null)
            ?? (name ? apps.find(e => e.name.toLowerCase() === name.toLowerCase()) : null);
        return source(entry?.icon || id) || source(fallback);
    }

    // use a different way to load tray icons
    function trayIcon(source: string): string {
        // apps with their own icon dir send it as ?path=, the theme doesnt know those
        if (!source.startsWith("image://icon/") || source.includes("?path=")) return source;
        const name = source.slice("image://icon/".length).replace(/\?.*$/, "");
        return Quickshell.iconPath(name, true) !== "" ? source : Quickshell.iconPath("application-x-executable");
    }

    // get the icon name by absolute path
    function source(icon: string): string {
        if (icon.startsWith("/")) return "file://" + icon;
        if (icon.includes("://")) return icon;
        return Quickshell.iconPath(icon, true);
    }
}
