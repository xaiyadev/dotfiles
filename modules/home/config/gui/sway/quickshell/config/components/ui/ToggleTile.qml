import QtQuick
import QtQuick.Layouts
import qs.data

// quick settings tile with an icon, title and status line; click toggles it. with `hasMenu`
// there is an arrow on the right that opens its menu (right click on the tile does the same)
Rectangle {
    id: root

    property string icon: ""
    property string title: ""
    property bool active: false
    property string subtitle: active ? "On" : "Off"
    property bool hasMenu: false
    signal clicked()
    signal menuRequested()

    readonly property color baseColor: active ? Theme.surface1 : Theme.surface0

    Layout.fillWidth: true
    implicitHeight: 46
    radius: Theme.radius
    color: mouse.containsMouse ? Qt.lighter(baseColor, 1.15) : baseColor
    border { width: 1; color: Theme.surface1 }
    opacity: enabled ? 1 : 0.5
    Behavior on color { ColorAnimation { duration: Theme.fastAnimation } }

    ClickArea {
        id: mouse
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        // right click does the same as the arrow
        onClicked: (event) => {
            if (event.button === Qt.LeftButton) root.clicked();
            else if (root.hasMenu) root.menuRequested();
        }
    }

    RowLayout {
        anchors { fill: parent; leftMargin: 12; rightMargin: 8 }
        spacing: 10

        Icon {
            icon: root.icon
            size: Theme.smallIconSize
            color: root.active ? Theme.accent : Theme.subtext0
            Behavior on color { ColorAnimation { duration: Theme.fastAnimation } }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1

            StyledText {
                Layout.fillWidth: true
                text: root.title
                font.bold: true
                font.pixelSize: Theme.smallFontSize
                color: root.active ? Theme.text : Theme.subtext0
                Behavior on color { ColorAnimation { duration: Theme.fastAnimation } }
            }

            StyledText {
                Layout.fillWidth: true
                text: root.subtitle
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize
            }
        }

        // sits above the click area of the tile, so it takes the click itself; no background
        // since the hover color would be the same as an inactive tile
        IconButton {
            visible: root.hasMenu
            icon: "chevron_right"
            iconSize: 12
            showBackground: false
            onClicked: root.menuRequested()
        }
    }
}
