import QtQuick
import qs.data

// battery drawn like the Adwaita audio / Wi-Fi icons (2px outline, filled level);
// the fill pulses every 10s while charging
Item {
    id: root

    property real level: 1        // 0..1
    property bool charging: false
    property color color: Theme.text

    implicitWidth: Theme.iconSize
    implicitHeight: Theme.iconSize

    // outline (16px grid scaled to the icon size, like the theme icons)
    Rectangle {
        id: body
        x: root.width * 0.5 / 16
        width: root.width * 13.5 / 16
        height: root.height * 10 / 16
        anchors.verticalCenter: parent.verticalCenter
        radius: height * 0.25
        color: "transparent"
        border { width: root.width * 2 / 16; color: root.color }

        // level
        Rectangle {
            id: fill
            readonly property real pad: body.border.width + root.width * 1 / 16

            x: pad
            y: pad
            height: body.height - 2 * pad
            width: Math.max(height * 0.4, (body.width - 2 * pad) * Math.max(0, Math.min(1, root.level)))
            radius: root.width * 0.75 / 16
            color: root.color
        }
    }

    // one pulse every 10s instead of a looping one, that would redraw the bar all the time
    Timer {
        interval: 10000
        running: root.charging
        repeat: true
        triggeredOnStart: true
        onTriggered: pulse.restart()
        onRunningChanged: if (!running) {
            pulse.stop();
            fill.opacity = 1;
        }
    }

    SequentialAnimation {
        id: pulse
        NumberAnimation { target: fill; property: "opacity"; to: 0.35; duration: 900; easing.type: Easing.InOutSine }
        NumberAnimation { target: fill; property: "opacity"; to: 1; duration: 900; easing.type: Easing.InOutSine }
    }

    // terminal
    Rectangle {
        x: body.x + body.width + root.width * 0.5 / 16
        width: root.width * 1.5 / 16
        height: body.height * 0.4
        anchors.verticalCenter: parent.verticalCenter
        radius: width / 2
        color: root.color
    }
}
