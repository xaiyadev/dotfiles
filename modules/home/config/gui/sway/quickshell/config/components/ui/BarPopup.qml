pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.data

PanelWindow {
    id: popup

    required property Item trigger
    property bool triggerHovered: false
    property bool extraHovered: false
    property int cardWidth: 300

    // extra cards stacked below the main one (e.g. notifications, media, ...)
    property list<Component> cards: []

    default property alias content: mainCard.content

    readonly property bool open: ShellState.currentPopup === popup
    readonly property var barWindow: trigger.QsWindow.window

    // horizontal card position on the screen (computed when opening)
    property real cardX: 0

    function toggle(): void {
        if (!open) updatePosition();
        ShellState.togglePopup(popup);
    }

    function close(): void { ShellState.closePopup(popup); }

    onCardWidthChanged: if (open) updatePosition()
    Component.onDestruction: ShellState.closePopup(popup)

    // centred below the trigger, kept on screen
    function updatePosition(): void {
        const barX = barWindow?.margins.left ?? 0;
        const centre = barX + trigger.mapToItem(null, trigger.width / 2, 0).x;
        const maxX = (screen ? screen.width : 0) - cardWidth - Theme.barMargin;
        cardX = Math.max(Theme.barMargin, Math.min(maxX, centre - cardWidth / 2));
    }

    screen: barWindow?.screen ?? null

    anchors { top: true; bottom: true; left: true; right: true }

    // respect the exclusive zone of the bar so the overlay starts right below it
    exclusionMode: ExclusionMode.Normal
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-popup"

    // shown on open, hidden after the close animation
    visible: false
    onOpenChanged: if (open) visible = true

    mask: Region { item: clipArea }

    // short delay so crossing the gap between trigger and card doesnt close it
    Timer {
        interval: 250
        running: popup.open && !popup.triggerHovered && !bridge.containsMouse && !cardHover.hovered && !popup.extraHovered
        onTriggered: popup.close()
    }

    // space between the bar and the popup, allowing the curser to be their
    // even tho the we are not officialy in the card anymore
    MouseArea {
        id: bridge
        parent: popup.barWindow?.contentItem ?? null
        z: -1
        enabled: popup.open
        x: popup.cardX - (popup.barWindow?.margins.left ?? 0)
        width: popup.cardWidth
        height: parent?.height ?? 0
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    // the cards slide down out of this area
    Item {
        id: clipArea
        x: popup.cardX
        width: popup.cardWidth
        height: stack.implicitHeight + Theme.popupGap
        clip: true

        HoverHandler { id: cardHover }

        ColumnLayout {
            id: stack
            width: parent.width
            spacing: Theme.popupGap

            y: popup.open ? Theme.popupGap : -implicitHeight
            opacity: popup.open ? 1 : 0

            Behavior on y {
                NumberAnimation {
                    duration: Theme.slowAnimation
                    easing.type: Easing.OutCubic
                    onRunningChanged: if (!running && !popup.open) popup.visible = false
                }
            }
            Behavior on opacity { NumberAnimation { duration: Theme.mediumAnimation } }

            Card {
                id: mainCard
                Layout.fillWidth: true
            }

            Repeater {
                model: popup.cards
                Card {
                    id: extraCard
                    Layout.fillWidth: true
                    required property Component modelData
                    Loader { Layout.fillWidth: true; sourceComponent: extraCard.modelData }
                }
            }
        }
    }
}
