import QtQuick
import "../../data"

// Small clickable icon (calendar arrows, close, copy, ...), optionally with a hover / selected background
Rectangle {
    id: root

    property string icon: ""
    property int iconSize: 14
    property bool selected: false
    property bool showBackground: true
    property color iconColor: selected || hovered ? Theme.text : Theme.subtext0
    readonly property bool hovered: mouse.containsMouse
    signal clicked()

    implicitWidth: iconSize + (showBackground ? 12 : 6)
    implicitHeight: implicitWidth
    radius: 6
    color: !showBackground ? "transparent" : selected ? Theme.surface1 : hovered ? Theme.surface0 : "transparent"

    Icon {
        anchors.centerIn: parent
        icon: root.icon
        size: root.iconSize
        color: root.iconColor
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
