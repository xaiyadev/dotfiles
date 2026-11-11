import QtQuick
import QtQuick.Layouts
import "../../data"

// 1px line between sections of a popup (horizontal, or vertical between columns)
Rectangle {
    property bool vertical: false

    Layout.fillWidth: !vertical
    Layout.fillHeight: vertical
    implicitWidth: 1
    implicitHeight: 1
    color: Theme.surface0
}
