import QtQuick
import QtQuick.Layouts
import "../../data"

// greyed out "nothing here" text ("No notifications", "Wi-Fi is off", ...)
StyledText {
    Layout.fillWidth: true
    Layout.topMargin: 4
    Layout.bottomMargin: 4
    horizontalAlignment: Text.AlignHCenter
    color: Theme.overlay0
    font.pixelSize: Theme.smallFontSize
}