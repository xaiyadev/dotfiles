import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../data"
import "ui"

// Menu of a tray item, drawn in the bar's style (instead of Qt's unstyled platform menu).
// Submenus open in place with a "Back" row.
ColumnLayout {
    id: root

    required property var menu      // QsMenuHandle of the tray item
    signal done()                   // an entry was triggered

    // opened submenus, innermost last
    property var stack: []
    readonly property var current: stack.length > 0 ? stack[stack.length - 1] : menu

    Layout.fillWidth: true
    spacing: 0

    QsMenuOpener {
        id: opener
        menu: root.current
    }

    // inside a submenu: "‹ Back" goes one level back
    MenuRow {
        Layout.fillWidth: true
        visible: root.stack.length > 0
        icon: "go-previous-symbolic"
        text: "Back"
        bold: true
        onClicked: root.stack = root.stack.slice(0, -1)
    }

    Separator {
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        visible: root.stack.length > 0
    }

    Repeater {
        model: opener.children

        Item {
            id: entry
            required property QsMenuEntry modelData

            Layout.fillWidth: true
            implicitHeight: modelData.isSeparator ? 9 : row.implicitHeight

            Separator {
                visible: entry.modelData.isSeparator
                anchors.centerIn: parent
                width: parent.width
            }

            MenuRow {
                id: row
                anchors { left: parent.left; right: parent.right }
                visible: !entry.modelData.isSeparator
                enabled: entry.modelData.enabled
                // DBus menus mark mnemonics with "_" ("_Quit")
                text: entry.modelData.text.replace(/_(?!_)/g, "")
                iconSource: entry.modelData.icon
                checkable: entry.modelData.buttonType !== QsMenuButtonType.None
                checked: entry.modelData.checkState === Qt.Checked
                submenu: entry.modelData.hasChildren

                onClicked: {
                    if (entry.modelData.hasChildren) {
                        root.stack = [...root.stack, entry.modelData];
                    } else {
                        entry.modelData.triggered();
                        root.done();
                    }
                }
            }
        }
    }

    component MenuRow: Rectangle {
        id: menuRow

        property string icon: ""          // theme icon
        property string iconSource: ""    // icon from the app (image source)
        property string text: ""
        property bool checkable: false
        property bool checked: false
        property bool submenu: false
        property bool bold: false
        signal clicked()

        implicitHeight: 30
        radius: 6
        color: mouse.containsMouse && enabled ? Theme.surface0 : "transparent"
        opacity: enabled ? 1 : 0.4

        RowLayout {
            anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
            spacing: 8

            // check mark / app icon / theme icon, fixed column so texts line up
            Item {
                implicitWidth: 16
                implicitHeight: 16
                visible: menuRow.checkable || menuRow.icon !== "" || menuRow.iconSource !== ""

                Icon {
                    anchors.fill: parent
                    visible: menuRow.checkable ? menuRow.checked : menuRow.icon !== ""
                    icon: menuRow.checkable ? "object-select-symbolic" : menuRow.icon
                    color: menuRow.checkable ? Theme.accent : Theme.text
                }

                IconImage {
                    anchors.fill: parent
                    visible: !menuRow.checkable && menuRow.icon === "" && menuRow.iconSource !== ""
                    source: menuRow.iconSource
                }
            }

            StyledText {
                Layout.fillWidth: true
                text: menuRow.text
                font.pixelSize: Theme.smallFontSize + 1
                font.bold: menuRow.bold
            }

            Icon {
                visible: menuRow.submenu
                icon: "go-next-symbolic"
                size: 12
                color: Theme.subtext0
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: menuRow.clicked()
        }
    }
}
