import QtQuick
import QtQuick.Layouts
import "../../data"

// Clickable row: icon, title, optional subtitle, trailing text / icon
Rectangle {
    id: root

    property string icon: ""
    property string text: ""
    property string subtext: ""
    property string trailing: ""
    property string trailingIcon: ""
    property bool active: false
    property bool interactive: true
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: subtext !== "" ? 44 : 34
    radius: 8
    color: mouse.containsMouse && interactive ? Theme.surface0 : "transparent"

    RowLayout {
        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
        spacing: 10

        Icon {
            icon: root.icon
            size: 16
            color: root.active ? Theme.accent : Theme.text
            visible: root.icon !== ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                Layout.fillWidth: true
                text: root.text
                color: root.active ? Theme.accent : Theme.text
                font.pixelSize: Theme.smallFontSize + 1
                font.bold: root.active
            }

            StyledText {
                Layout.fillWidth: true
                visible: root.subtext !== ""
                text: root.subtext
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize - 1
            }
        }

        StyledText {
            visible: root.trailing !== ""
            text: root.trailing
            color: Theme.subtext0
            font.pixelSize: Theme.smallFontSize
        }

        Icon {
            visible: root.trailingIcon !== ""
            icon: root.trailingIcon
            size: 12
            color: Theme.subtext0
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.interactive
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
