import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../data"
import "../ui"

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: 20

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Icon { icon: Pipewire.sinkIcon; color: Theme.subtext0 }
        Icon { icon: Network.icon; color: Theme.subtext0 }

        // notification bell, the dot shows while there is anything in the history (not in do-not-disturb)
        Icon {
            Layout.leftMargin: 6
            icon: Notifications.doNotDisturb ? "notifications_off" : "notifications"
            Rectangle {
                visible: Notifications.count > 0 && !Notifications.doNotDisturb
                anchors { right: parent.right; bottom: parent.bottom; rightMargin: -3; bottomMargin: -2 }
                width: 8; height: 8; radius: 4
                color: Theme.accent
                border { width: 2; color: Theme.base }
            }
        }

        Battery { spacing: 10 }
    }

    ClickArea { id: mouse; onClicked: popup.toggle() }

    ControlPopup {
        id: popup
        trigger: root
        triggerHovered: mouse.containsMouse
    }
}
