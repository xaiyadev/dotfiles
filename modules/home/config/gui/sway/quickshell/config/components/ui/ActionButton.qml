import QtQuick
import QtQuick.Layouts
import "../../data"

// small button, e.g. "Network settings" in a menu or an action on a notification;
// `highlighted` is for the main action and gets the accent as background
Rectangle {
    id: root

    property string icon: ""
    property string text: ""
    property bool highlighted: false
    signal clicked()

    readonly property color foreground: highlighted ? Theme.base : Theme.text

    implicitHeight: 30
    implicitWidth: content.implicitWidth + 24
    radius: Theme.mediumRadius
    color: highlighted
        ? (mouse.containsMouse ? Qt.lighter(Theme.accent, 1.08) : Theme.accent)
        : (mouse.containsMouse ? Theme.surface1 : Theme.surface0)

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 8

        Icon { icon: root.icon; size: 14; color: root.foreground; visible: root.icon !== "" }
        StyledText {
            text: root.text
            color: root.foreground
            font.bold: root.highlighted
            font.pixelSize: Theme.smallFontSize
        }
    }

    ClickArea { id: mouse; onClicked: root.clicked() }
}
