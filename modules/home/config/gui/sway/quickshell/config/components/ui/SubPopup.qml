import QtQuick
import Quickshell
import qs.data


PopupWindow {
    id: root

    default property alias content: card.content

    property bool shown: false
    readonly property bool hovered: hover.hovered

    // minHeight needed even if the content changes (e.g WIFI scans)
    property int reservedHeight: 0

    function open(): void {
        shown = false;
        visible = true;
        Qt.callLater(() => { shown = true; });
    }

    // just starts the animation, it will close by itself
    function close(): void { shown = false; }

    // open this popup right below the item given
    function toggleBelow(item: Item): void {
        if (shown) return close();

        anchor.window = item.QsWindow.window;
        const pos = item.mapToItem(anchor.window.contentItem, 0, item.height + 4);
        anchor.rect.x = Math.round(pos.x);
        anchor.rect.y = Math.round(pos.y);

        open();
    }

    visible: false
    color: "transparent"

    implicitWidth: 240
    implicitHeight: Math.max(card.implicitHeight, reservedHeight)

    mask: Region { item: card }

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
