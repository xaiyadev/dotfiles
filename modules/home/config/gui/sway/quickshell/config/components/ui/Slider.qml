import QtQuick
import qs.data

Item {
    id: root

    property real value: 0
    property bool live: true
    readonly property bool dragging: mouse.pressed
    property real dragValue: 0
    signal moved(real value)

    implicitHeight: 16

    function clamp(v: real): real { return Math.max(0, Math.min(1, v)); }

    function drag(v: real): void {
        dragValue = clamp(v);
        if (live) moved(dragValue);
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 8
        radius: 3
        color: Theme.surface0

        Rectangle {
            width: parent.width * root.clamp(root.dragging && !root.live ? root.dragValue : root.value)
            height: parent.height
            radius: 3
            color: Theme.text
        }
    }

    ClickArea {
        id: mouse
        hoverEnabled: false
        onPressed: (event) => root.drag(event.x / width)
        onPositionChanged: (event) => root.drag(event.x / width)
        onReleased: if (!root.live) root.moved(root.dragValue)
        onWheel: (event) => root.moved(root.clamp(root.value + (event.angleDelta.y > 0 ? 0.02 : -0.02)))
    }
}
