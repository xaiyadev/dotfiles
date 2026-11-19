pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // music players that win over every other player in the media panel
    readonly property list<string> musicPlayers: ["sone", "tidal", "spotify"]

    // tray items that should be hidden
    readonly property list<string> hiddenTrayItems: [
        "vicinae",     // launcher
        "nm-applet"    // network, see the Wi-Fi popup
    ]

    // the battery charge limit; percent gets scaled so that this shows up as 100%
    readonly property int chargeLimit: 80

    // gravatar hashes per user for the avatar in the control popup
    readonly property var avatars: ({
        "xaiya":   "3c840e20aedb665ac4a8b5d1daaf8fd9",
        "blmedia": "6d8aebedc2d80c49e6f1e86a2e9e0c1f"
    })

    // looked up in the user profile, the packages for it are in default.nix
    readonly property string profileShare: "/etc/profiles/per-user/" + Quickshell.env("USER") + "/share/"

    // played for every toast
    readonly property string notificationSound: profileShare + "sounds/freedesktop/stereo/message-new-instant.oga"
}
