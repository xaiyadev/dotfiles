import QtQuick
import qs.data

// small clickable icon (device picker, clear all, ...), can have a hover / selected background
Rectangle {
    id: root

    property string icon: ""
    property int iconSize: 14
    property bool selected: false
    property bool showBackground: true
    readonly property bool hovered: mouse.containsMouse
    signal clicked()

    implicitWidth: iconSize + (showBackground ? 12 : 6)
    implicitHeight: implicitWidth
    radius: Theme.smallRadius
    color: !showBackground ? "transparent" : selected ? Theme.surface1 : hovered ? Theme.surface0 : "transparent"

    Icon {
        anchors.centerIn: parent
        icon: root.icon
        size: root.iconSize
        color: root.selected || root.hovered ? Theme.text : Theme.subtext0
    }

    ClickArea { id: mouse; onClicked: root.clicked() }
}
