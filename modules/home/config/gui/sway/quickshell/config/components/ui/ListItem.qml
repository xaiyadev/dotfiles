import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../data"

// clickable row with an icon, title, optional subtitle and a trailing icon; `compact` is the
// tighter one for the tray menus
Rectangle {
    id: root

    property string icon: ""
    // image instead of a symbol (tray menus send those), only used without `icon`
    property string iconSource: ""
    property color iconColor: active ? Theme.accent : Theme.text
    // keeps the icon column without an icon, so the texts of a menu line up
    property bool reserveIcon: false
    property string text: ""
    property string subtext: ""
    property string trailingIcon: ""
    property bool active: false
    property bool bold: active
    property bool compact: false
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: compact ? 30 : subtext !== "" ? 44 : 34
    radius: compact ? Theme.smallRadius : Theme.mediumRadius
    color: mouse.containsMouse ? Theme.surface0 : "transparent"
    opacity: enabled ? 1 : 0.4

    RowLayout {
        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
        spacing: root.compact ? 8 : 10

        Item {
            implicitWidth: Theme.smallIconSize
            implicitHeight: Theme.smallIconSize
            visible: root.reserveIcon || root.icon !== "" || root.iconSource !== ""

            Icon {
                anchors.centerIn: parent
                icon: root.icon
                size: Theme.smallIconSize
                color: root.iconColor
            }

            IconImage {
                anchors.fill: parent
                visible: root.icon === "" && root.iconSource !== ""
                source: root.iconSource
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                Layout.fillWidth: true
                text: root.text
                color: root.active ? Theme.accent : Theme.text
                font.pixelSize: Theme.mediumFontSize
                font.bold: root.bold
            }

            StyledText {
                Layout.fillWidth: true
                visible: root.subtext !== ""
                text: root.subtext
                color: Theme.subtext0
                font.pixelSize: Theme.tinyFontSize
            }
        }

        Icon {
            visible: root.trailingIcon !== ""
            icon: root.trailingIcon
            size: 12
            color: Theme.subtext0
        }
    }

    ClickArea { id: mouse; onClicked: root.clicked() }
}
