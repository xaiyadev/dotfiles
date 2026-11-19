pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../data"
import "ui"

// menu of a tray item in the bars style instead of qts unstyled platform menu;
// submenus open in place with a "Back" row
ColumnLayout {
    id: root

    required property var menu
    signal done()

    // submenus we went into, the last one is shown
    property var stack: []
    readonly property var current: stack.length > 0 ? stack[stack.length - 1] : menu

    readonly property bool hasIconColumn: stack.length > 0 || opener.children.values.some(e =>
        !e.isSeparator && (e.icon !== "" || e.buttonType !== QsMenuButtonType.None))

    // another tray item: start at its top level again
    onMenuChanged: stack = []

    Layout.fillWidth: true
    spacing: 0

    QsMenuOpener {
        id: opener
        menu: root.current
    }

    // inside a submenu "Back" goes one level up
    ListItem {
        visible: root.stack.length > 0
        compact: true
        reserveIcon: root.hasIconColumn
        icon: "chevron_left"
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
            readonly property bool checkable: modelData.buttonType !== QsMenuButtonType.None

            Layout.fillWidth: true
            implicitHeight: modelData.isSeparator ? 9 : row.implicitHeight

            Separator {
                visible: entry.modelData.isSeparator
                anchors.centerIn: parent
                width: parent.width
            }

            ListItem {
                id: row
                anchors { left: parent.left; right: parent.right }
                visible: !entry.modelData.isSeparator
                enabled: entry.modelData.enabled
                compact: true
                reserveIcon: root.hasIconColumn
                // check boxes / radio buttons show a check mark while checked, others their icon
                icon: entry.checkable && entry.modelData.checkState === Qt.Checked ? "check" : ""
                iconSource: entry.checkable ? "" : entry.modelData.icon
                iconColor: Theme.accent
                // DBus menus mark mnemonics with "_" ("_Quit")
                text: entry.modelData.text.replace(/_(?!_)/g, "")
                trailingIcon: entry.modelData.hasChildren ? "chevron_right" : ""

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
}
