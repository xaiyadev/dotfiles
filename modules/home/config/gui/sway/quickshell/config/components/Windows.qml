import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Wayland
import "../data"
import "../services"
import "ui"

// Icon + title of the focused window (on the screen it is on)
RowLayout {
    id: root

    required property var screen

    readonly property var active: ToplevelManager.activeToplevel
    readonly property bool onThisScreen: active?.screens.some(s => s.name === root.screen?.name) ?? false

    visible: onThisScreen && (active?.title ?? "") !== ""
    spacing: 8

    IconImage {
        implicitSize: 20
        source: Apps.iconPath(root.active?.appId ?? "", "", "application-x-executable")
    }

    StyledText {
        Layout.maximumWidth: 360
        text: root.active?.title ?? ""
        color: Theme.subtext0
    }
}
