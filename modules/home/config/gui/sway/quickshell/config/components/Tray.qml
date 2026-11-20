pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.services
import qs.data
import qs.components.ui

RowLayout {
    id: root

    // without the items hidden in Config.hiddenTrayItems
    readonly property var items: SystemTray.items.values.filter(item => !Config.hiddenTrayItems.includes(item.id))

    // tray icon whose menu was opened last (only open while menuPopup.open)
    property Item menuItem: null

    function toggleMenu(item: Item): void {
        if (!item.modelData.hasMenu) return;
        // menu of another icon is open, so just move it over
        const switching = menuPopup.open && menuItem !== item;
        menuItem = item;
        if (switching) menuPopup.updatePosition();
        else menuPopup.toggle();
    }

    visible: items.length > 0
    spacing: 4

    Repeater {
        model: ScriptModel { values: root.items }

        MouseArea {
            id: trayItem
            required property SystemTrayItem modelData
            readonly property bool menuOpen: menuPopup.open && root.menuItem === trayItem

            implicitWidth: Theme.iconSize + 8
            implicitHeight: Theme.iconSize + 8
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            cursorShape: Qt.PointingHandCursor

            onClicked: (event) => {
                if (event.button === Qt.RightButton) root.toggleMenu(trayItem);
                else if (event.button === Qt.MiddleButton) modelData.secondaryActivate();
                else if (modelData.onlyMenu) root.toggleMenu(trayItem);
                else modelData.activate();
            }
            onWheel: (event) => modelData.scroll(event.angleDelta.y, false)

            // hover / menu-open background
            Rectangle {
                anchors.fill: parent
                radius: Theme.smallRadius
                color: trayItem.menuOpen ? Theme.surface1 : trayItem.containsMouse ? Theme.surface0 : "transparent"
            }

            IconImage {
                anchors.centerIn: parent
                implicitSize: Theme.iconSize
                source: AppIcons.trayIcon(trayItem.modelData.icon)
            }
        }
    }

    BarPopup {
        id: menuPopup
        trigger: root.menuItem ?? root
        triggerHovered: root.menuItem?.containsMouse ?? false
        cardWidth: 240

        // only loaded while open, otherwise every apps dbus menu would get fetched; a new instance
        // every time also means it starts at the top level again
        Loader {
            Layout.fillWidth: true
            active: menuPopup.visible && root.menuItem !== null
            sourceComponent: TrayMenu {
                menu: root.menuItem.modelData.menu
                onDone: menuPopup.close()
            }
        }
    }
}
