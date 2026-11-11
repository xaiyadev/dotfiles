import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../data"

// Card that drops down out of the bar below its trigger.
// Transparent overlay on the trigger's screen; only the card takes input.
// Closes when the mouse is over neither the trigger, the bar above the card, nor the card.
PanelWindow {
    id: popup

    required property Item trigger
    property bool triggerHovered: false
    property string kind: ""
    property int cardWidth: 300

    default property alias content: column.data

    readonly property bool open: Popups.current === popup
    readonly property var barWindow: trigger.QsWindow.window

    // horizontal card position on the screen (computed when opening)
    property real cardX: 0

    function toggle(): void {
        if (!open) updatePosition();
        Popups.toggle(popup);
    }

    function close(): void { Popups.close(popup); }

    onCardWidthChanged: if (open) updatePosition()

    // centred below the trigger, kept on screen
    function updatePosition(): void {
        const barX = barWindow?.margins.left ?? 0;
        const centre = barX + trigger.mapToItem(null, trigger.width / 2, 0).x;
        const maxX = (screen ? screen.width : 0) - cardWidth - Theme.barMargin;
        cardX = Math.max(Theme.barMargin, Math.min(maxX, centre - cardWidth / 2));
    }

    screen: barWindow?.screen ?? null

    anchors { top: true; bottom: true; left: true; right: true }
    // respect the bars' exclusive zones -> the overlay starts directly below the bar
    exclusionMode: ExclusionMode.Normal
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-popup"
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    // shown on open, hidden after the close animation
    visible: false
    onOpenChanged: if (open) visible = true

    mask: Region { item: clipArea }

    Timer {
        interval: 250
        running: popup.open && !popup.triggerHovered && !bridge.containsMouse && !cardHover.hovered
        onTriggered: popup.close()
    }

    // part of the bar directly above the card: keeps the popup open while moving between
    // trigger and card. Lives in the bar window, underneath the modules, takes no buttons.
    // (MouseArea, not HoverHandler: HoverHandler stays "hovered" when the pointer moves
    // straight into another surface)
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

    // the card slides down out of this area
    Item {
        id: clipArea
        x: popup.cardX
        width: popup.cardWidth
        height: card.height + Theme.popupGap
        clip: true

        HoverHandler { id: cardHover }

        Rectangle {
            id: card
            width: parent.width
            height: column.implicitHeight + 32
            radius: Theme.radius
            color: Theme.base
            border { width: 1; color: Theme.surface0 }

            y: popup.open ? Theme.popupGap : -height
            opacity: popup.open ? 1 : 0

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                    onRunningChanged: if (!running && !popup.open) popup.visible = false
                }
            }
            Behavior on opacity { NumberAnimation { duration: 200 } }

            focus: true
            Keys.onEscapePressed: popup.close()

            ColumnLayout {
                id: column
                anchors { top: parent.top; left: parent.left; right: parent.right; margins: 16 }
                spacing: 10
            }
        }
    }
}
