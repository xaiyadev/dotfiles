import QtQuick
import QtQuick.Layouts
import qs.services
import qs.data
import qs.components.ui

// battery icon and percentage; hidden on machines without a battery
RowLayout {
    id: root

    property int fontSize: Theme.fontSize
    readonly property color levelColor: Power.percent <= 20 ? Theme.red
        : Power.percent <= 30 ? Theme.peach
        : Theme.text

    visible: Power.present
    spacing: 6

    BatteryIcon {
        level: Power.percent / 100
        charging: Power.charging
        color: root.levelColor
    }

    StyledText {
        text: Power.percent + "%"
        color: root.levelColor
        font.pixelSize: root.fontSize
    }
}