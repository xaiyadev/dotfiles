pragma Singleton

import Quickshell
import QtQuick

// Nerd Font glyphs, taken over from the waybar config
Singleton {
    function g(codePoint: int): string { return String.fromCodePoint(codePoint); }

    // sway workspace name -> icon
    readonly property var workspaces: ({
        "1": g(0xF121), "2": g(0xF269), "3": g(0xF489), "4": g(0xF0558), "5": g(0xF1741),
        "6": g(0xEE82), "7": g(0xEF63), "8": g(0xF51E), "9": g(0xF1545), "10": g(0xEF15)
    })

}
