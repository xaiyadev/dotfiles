import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../services"
import "../data"
import "ui"

// System tray: left click activates (or opens the menu if that's all the item has),
// right click opens the item's menu (drawn in the bar's style, see TrayMenu),
// middle click secondary action, scroll forwarded.
RowLayout {
    id: root

    // without the items hidden in Config.hiddenTrayItems
    readonly property var items: SystemTray.items.values.filter(item => !Config.hiddenTrayItems.includes(item.id))

    visible: items.length > 0
    spacing: 10

    Repeater {
        model: ScriptModel { values: root.items }

        MouseArea {
            id: trayItem
            required property SystemTrayItem modelData

            implicitWidth: 20
            implicitHeight: 20
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            cursorShape: Qt.PointingHandCursor

            function toggleMenu(): void {
                if (modelData.hasMenu) menuPopup.toggle();
            }

            onClicked: (event) => {
                if (event.button === Qt.RightButton) toggleMenu();
                else if (event.button === Qt.MiddleButton) modelData.secondaryActivate();
                else if (modelData.onlyMenu) toggleMenu();
                else modelData.activate();
            }
            onWheel: (event) => modelData.scroll(event.angleDelta.y, false)

            // the app's icon; if the theme doesn't have it (e.g. EasyEffects only ships it in its
            // own package) the Papirus version, then a generic one
            Image {
                id: trayIcon
                property int attempt: 0
                readonly property var sources: [
                    Apps.trayIcon(trayItem.modelData.icon),
                    Quickshell.iconPath("application-x-executable")
                ]

                anchors.fill: parent
                sourceSize { width: 40; height: 40 }
                source: sources[attempt]
                onStatusChanged: if (status === Image.Error && attempt < sources.length - 1) attempt++
                onSourcesChanged: attempt = 0
            }

            BarPopup {
                id: menuPopup
                trigger: trayItem
                triggerHovered: trayItem.containsMouse
                kind: "tray"
                cardWidth: 240

                // only loaded while open (otherwise every app's DBus menu would be fetched);
                // a new instance every time also starts at the top level again
                Loader {
                    Layout.fillWidth: true
                    active: menuPopup.visible
                    sourceComponent: TrayMenu {
                        menu: trayItem.modelData.menu
                        onDone: menuPopup.close()
                    }
                }
            }
        }
    }
}
