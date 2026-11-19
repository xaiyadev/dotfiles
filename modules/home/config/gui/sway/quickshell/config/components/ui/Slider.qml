import QtQuick
import "../../data"

// horizontal 0..1 slider, click, drag or scroll it
Item {
    id: root

    property real value: 0
    signal moved(real value)

    implicitHeight: 16

    function emit(v: real): void { root.moved(Math.max(0, Math.min(1, v))); }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 8
        radius: 3
        color: Theme.surface0

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, root.value))
            height: parent.height
            radius: 3
            color: Theme.text
        }
    }

    ClickArea {
        // without hover positionChanged only comes while pressed, otherwise just moving over it would set the value
        hoverEnabled: false
        onPressed: (event) => root.emit(event.x / width)
        onPositionChanged: (event) => root.emit(event.x / width)
        onWheel: (event) => root.emit(root.value + (event.angleDelta.y > 0 ? 0.02 : -0.02))
    }
}
