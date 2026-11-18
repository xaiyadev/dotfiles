pragma Singleton

import Quickshell
import QtQuick

// Personal settings in one place
Singleton {
    // players that count as "real" music players and beat e.g. a browser (identity / desktop entry)
    readonly property list<string> musicPlayers: ["sone", "tidal", "spotify"]

    // tray items that are not shown (item id)
    readonly property list<string> hiddenTrayItems: [
        "vicinae",     // launcher
        "nm-applet"    // network, see the Wi-Fi popup
    ]

    readonly property list<string> preferredMainMonitors: [
        "AOC CQ32G4"    // home
    ]

    // icons the Adwaita theme doesn't have are taken from here (e.g. EasyEffects in the tray)
    readonly property string fallbackIconDir: "/etc/profiles/per-user/" + Quickshell.env("USER") + "/share/icons/Papirus/22x22/apps/"
}
