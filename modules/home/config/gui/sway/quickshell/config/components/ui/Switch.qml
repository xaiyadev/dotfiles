import QtQuick
import "../../data"

Rectangle {
    id: root

    property bool checked: false
    signal toggled()

    implicitWidth: 34
    implicitHeight: 18
    radius: height / 2
    color: checked ? Theme.accent : Theme.surface1
    Behavior on color { ColorAnimation { duration: 150 } }

    Rectangle {
        width: 14
        height: 14
        radius: 7
        y: 2
        x: root.checked ? root.width - width - 2 : 2
        color: Theme.base
        Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
