pragma Singleton

import Quickshell
import QtQuick

// Colours (Catppuccin Mocha), fonts and shared geometry
Singleton {
    readonly property color base: "#1e1e2e"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color overlay0: "#6c7086"
    readonly property color subtext0: "#a6adc8"
    readonly property color text: "#cdd6f4"
    readonly property color flamingo: "#f2cdcd"
    readonly property color rosewater: "#f5e0dc"
    readonly property color red: "#f38ba8"
    readonly property color peach: "#fab387"

    readonly property color accent: flamingo

    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 14
    readonly property int smallFontSize: 12
    readonly property int iconSize: 18

    readonly property int radius: 12

    // bar geometry, popups line up with it
    readonly property int barHeight: 36
    readonly property int barMargin: 10
    readonly property int popupGap: 8
}
