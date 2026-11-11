import QtQuick
import QtQuick.Layouts
import "../../data"

// Bar entry: icon (+ optional text); left click opens a popup with the full picture.
// Children are placed into the popup card.
Item {
    id: root

    property string icon: ""           // theme icon name or file (data/Icons.qml)
    // or a custom icon item instead (e.g. the drawn battery)
    property Component iconDelegate: null
    property string text: ""
    property color color: Theme.text
    // small dot on the icon (e.g. unread notifications, Tailscale connected)
    property bool badge: false

    // popup
    property string kind: ""
    property int popupWidth: 300
    default property alias content: popup.content
    readonly property alias popup: popup

    readonly property alias row: layout
    readonly property bool hovered: mouse.containsMouse

    signal middleClicked()
    signal scrolled(int delta)

    implicitWidth: layout.implicitWidth
    implicitHeight: 20

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 0

        // icon with the optional badge dot
        Item {
            implicitWidth: Theme.iconSize
            implicitHeight: Theme.iconSize
            visible: root.icon !== "" || root.iconDelegate !== null

            Icon {
                anchors.fill: parent
                icon: root.icon
                color: root.color
                visible: root.icon !== ""
            }

            Loader {
                anchors.fill: parent
                active: root.iconDelegate !== null
                sourceComponent: root.iconDelegate
            }

            Rectangle {
                visible: root.badge
                anchors { right: parent.right; bottom: parent.bottom; rightMargin: -3; bottomMargin: -2 }
                width: 8
                height: 8
                radius: 4
                color: Theme.accent
                border { width: 2; color: Theme.base }
            }
        }

        StyledText {
            Layout.leftMargin: root.icon !== "" || root.iconDelegate !== null ? 6 : 0
            Layout.maximumWidth: 160
            text: root.text
            color: root.color
            visible: root.text !== ""
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor

        onClicked: (event) => {
            if (event.button === Qt.MiddleButton) root.middleClicked();
            else popup.toggle();
        }
        onWheel: (event) => root.scrolled(event.angleDelta.y)

        // menu-bar behaviour: while another popup is open, hovering switches to this one
        onContainsMouseChanged: {
            if (containsMouse && Popups.current !== null && !popup.open) popup.toggle();
        }
    }

    BarPopup {
        id: popup
        trigger: root
        triggerHovered: root.hovered
        kind: root.kind
        cardWidth: root.popupWidth
    }
}
