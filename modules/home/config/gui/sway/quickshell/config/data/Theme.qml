pragma Singleton

import Quickshell
import QtQuick

// catppuccin mocha colors and the rest of the look (fonts, sizes, spacing, animations)
Singleton {
    readonly property color base: "#1e1e2e"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color overlay0: "#6c7086"
    readonly property color subtext0: "#a6adc8"
    readonly property color text: "#cdd6f4"
    readonly property color flamingo: "#f2cdcd"
    readonly property color peach: "#fab387"
    readonly property color red: "#f38ba8"

    readonly property color accent: flamingo

    // fonts
    readonly property string font: "Maple Mono"
    readonly property int fontSize: 14
    readonly property int mediumFontSize: 13
    readonly property int smallFontSize: 12
    readonly property int tinyFontSize: 11

    // icons, material symbols from default.nix
    readonly property string iconFont: "Material Symbols Rounded"
    readonly property int iconSize: 18
    readonly property int smallIconSize: 16

    // corners; `radius` for the bar, cards and tiles, the others for things inside of them
    readonly property int radius: 12
    readonly property int mediumRadius: 8
    readonly property int smallRadius: 6

    // animation durations in ms
    readonly property int fastAnimation: 150
    readonly property int mediumAnimation: 200
    readonly property int slowAnimation: 250

    // bar and popup layout
    readonly property int barHeight: 36
    readonly property int barMargin: 10
    readonly property int popupGap: 8
}
