import QtQuick
import QtQuick.Layouts

// Popup title row with an optional on/off switch
RowLayout {
    id: root

    property string icon: ""
    property string title: ""
    property bool showSwitch: false
    property bool checked: false
    signal toggled()

    Layout.fillWidth: true
    spacing: 8

    Icon { icon: root.icon; size: 16; visible: root.icon !== "" }

    StyledText {
        Layout.fillWidth: true
        text: root.title
        font.bold: true
    }

    Switch {
        visible: root.showSwitch
        checked: root.checked
        onToggled: root.toggled()
    }
}
