import QtQuick
import Quickshell
import "ui"

StyledText {
    text: Qt.formatTime(clock.date, "HH:mm")

    SystemClock { id: clock; precision: SystemClock.Minutes }
}
