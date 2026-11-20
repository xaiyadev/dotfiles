import QtQuick
import QtQuick.Layouts
import qs.data

// 1px line; horizontal between sections of a popup or `vertical` between groups in the bar
Rectangle {
    property bool vertical: false

    Layout.fillWidth: !vertical
    implicitWidth: 1
    implicitHeight: vertical ? 14 : 1
    color: vertical ? Theme.surface1 : Theme.surface0
}