import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import "../../data"

// Symbolic theme icon, recoloured to a single colour
Item {
    id: root

    property string icon: ""
    property int size: Theme.iconSize
    property color color: Theme.text

    implicitWidth: size
    implicitHeight: size

    IconImage {
        anchors.fill: parent
        // theme icon name, or a file (own icons, see data/Icons.qml)
        source: root.icon === "" ? "" : root.icon.includes(":/") ? root.icon : Quickshell.iconPath(root.icon, true)

        layer.enabled: true
        layer.effect: MultiEffect {
            brightness: 1.0
            colorization: 1.0
            colorizationColor: root.color
        }
    }
}
