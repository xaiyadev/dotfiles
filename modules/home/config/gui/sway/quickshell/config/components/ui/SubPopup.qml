import QtQuick
import Quickshell
import "../../data"

// small card that drops down below an item inside a BarPopup (device pickers, network list, ...);
// children go into a ColumnLayout
PopupWindow {
    id: root

    default property alias content: card.content

    property bool shown: false
    readonly property bool hovered: hover.hovered

    function open(): void {
        shown = false;
        visible = true;
        Qt.callLater(() => { shown = true; });
    }

    // only starts the animation, the window hides itself once its done
    function close(): void { shown = false; }

    // opens below `item` (relative to the content of the parent popup) or closes it if open
    function toggleBelow(item: Item): void {
        if (shown) return close();
        const pos = item.mapToItem(anchor.window.contentItem, 0, item.height + 4);
        anchor.rect.x = Math.round(pos.x);
        anchor.rect.y = Math.round(pos.y);
        open();
    }

    visible: false
    color: "transparent"
    implicitWidth: 240
    implicitHeight: card.implicitHeight

    HoverHandler { id: hover }

    Card {
        id: card
        width: parent.width
        padding: 8
        spacing: 2

        opacity: root.shown ? 1 : 0
        y: root.shown ? 0 : -6

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.fastAnimation; easing.type: Easing.OutCubic
                onRunningChanged: if (!running && !root.shown) root.visible = false
            }
        }
        Behavior on y { NumberAnimation { duration: Theme.fastAnimation; easing.type: Easing.OutCubic } }
    }
}