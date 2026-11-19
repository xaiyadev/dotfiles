import QtQuick
import QtQuick.Layouts
import "../../data"

// icon (click to mute), slider, percentage and an optional device picker button
RowLayout {
    id: root

    property string icon: ""
    property real value: 0
    property bool showPicker: false
    property bool pickerOpen: false
    readonly property Item pickerButton: pickerBtn
    signal moved(real value)
    signal muteClicked()
    signal pickerClicked()

    Layout.fillWidth: true
    spacing: 10

    Icon {
        icon: root.icon
        size: Theme.smallIconSize
        ClickArea { onClicked: root.muteClicked() }
    }

    Slider {
        Layout.fillWidth: true
        value: root.value
        onMoved: (value) => root.moved(value)
    }

    StyledText {
        Layout.preferredWidth: 36
        text: Math.round(root.value * 100) + "%"
        color: Theme.subtext0
        horizontalAlignment: Text.AlignRight
        font.pixelSize: Theme.smallFontSize
    }

    IconButton {
        id: pickerBtn
        visible: root.showPicker
        icon: "tune"
        selected: root.pickerOpen
        onClicked: root.pickerClicked()
    }
}