pragma Singleton

import Quickshell
import QtQuick

// finds icons for apps through their desktop entry; only the icon theme (Adwaita, then hicolor
// where apps put their own icons) is used, nothing else
Singleton {
    // tries the id, then quickshells heuristic (name / StartupWMClass), then the display name
    function entryFor(id: string, name: string): var {
        DesktopEntries.applications.values; // so bindings update once the desktop entries are loaded
        return (id ? DesktopEntries.byId(id) : null)
            ?? (id ? DesktopEntries.heuristicLookup(id) : null)
            ?? (name ? DesktopEntries.heuristicLookup(name) : null)
            ?? (name ? DesktopEntries.applications.values.find(e => e.name.toLowerCase() === name.toLowerCase()) : null)
            ?? null;
    }

    // `fallback` is a theme icon for when the app has none we can find
    function iconPath(id: string, name: string, fallback: string): string {
        const iconName = entryFor(id, name)?.icon || id;
        return (iconName ? source(iconName) : "") || (fallback ? source(fallback) : "");
    }

    // tray icons come as image://icon/<name>, use a generic icon if the theme doesnt know the name
    function trayIcon(source: string): string {
        // apps with their own icon dir send it as ?path=, the theme doesnt know those
        if (!source.startsWith("image://icon/") || source.includes("?path=")) return source;
        const name = source.slice("image://icon/".length).replace(/\?.*$/, "");
        return Quickshell.iconPath(name, true) !== "" ? source : Quickshell.iconPath("application-x-executable");
    }

    // icon name, absolute path (some apps like kitty send one) or url to an image source;
    // empty if the theme doesnt have the icon
    function source(icon: string): string {
        if (icon.startsWith("/")) return "file://" + icon;
        if (icon.includes("://")) return icon;
        return Quickshell.iconPath(icon, true);
    }
}
