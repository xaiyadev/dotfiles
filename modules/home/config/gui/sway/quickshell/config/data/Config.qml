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

    // main monitor per setup ("<make> <model>"), see services/GameMode.qml; otherwise the
    // external monitor with the highest refresh rate is used
    readonly property list<string> preferredMainMonitors: [
        "AOC CQ32G4"    // home
    ]

    // sound for notification popups: freedesktop "message-new-instant", but with both channels
    // mixed evenly (the original is ~8 dB louder on the left, so it sounded one-sided)
    readonly property string notificationSound: Quickshell.shellPath("assets/sounds/notification.ogg")

    // icons the Adwaita theme doesn't have are taken from here (e.g. EasyEffects in the tray)
    readonly property string fallbackIconDir: "/etc/profiles/per-user/" + Quickshell.env("USER") + "/share/icons/Papirus/22x22/apps/"
}
