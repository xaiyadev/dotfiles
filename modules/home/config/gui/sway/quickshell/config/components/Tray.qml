pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../services"
import "../data"
import "ui"

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

            // tray icon names often dont resolve, so fall back to a generic icon
            Image {
                property int attempt: 0
                readonly property var sources: [
                    Apps.trayIcon(trayItem.modelData.icon),
                    Quickshell.iconPath("application-x-executable")
                ]

                anchors.centerIn: parent
                width: Theme.iconSize
                height: Theme.iconSize
                sourceSize { width: Theme.iconSize * 2; height: Theme.iconSize * 2 }
                source: sources[attempt]
                onStatusChanged: if (status === Image.Error && attempt < sources.length - 1) attempt++
                onSourcesChanged: attempt = 0
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
