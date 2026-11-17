import QtQuick
import Quickshell
import "../data"
import "ui"

Item {
    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    StyledText {
        id: timeText
        text: Qt.formatTime(clock.date, "HH:mm")
    }
}
