import QtQuick
import QtQuick.Layouts
import "../../data"

// "label ........ value" line for detail views
RowLayout {
    id: root

    property string label: ""
    property string value: ""
    property color valueColor: Theme.text

    Layout.fillWidth: true
    visible: value !== ""

    StyledText {
        Layout.fillWidth: true
        text: root.label
        color: Theme.subtext0
        font.pixelSize: Theme.smallFontSize + 1
    }

    StyledText {
        text: root.value
        color: root.valueColor
        font.pixelSize: Theme.smallFontSize + 1
    }
}
