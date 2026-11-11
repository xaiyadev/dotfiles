import QtQuick
import QtQuick.Layouts
import "../../data"

// Small button, e.g. "open the full app" at the bottom of a popup
Rectangle {
    id: root

    property string icon: ""
    property string text: ""
    signal clicked()

    implicitHeight: 30
    implicitWidth: content.implicitWidth + 24
    radius: 8
    color: mouse.containsMouse ? Theme.surface1 : Theme.surface0

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 8

        Icon { icon: root.icon; size: 14; visible: root.icon !== "" }
        StyledText { text: root.text; font.pixelSize: Theme.smallFontSize }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
