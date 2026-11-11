import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "../data"
import "ui"

// Clock. Popup: month calendar (scroll / arrows to change month).
BarModule {
    id: root

    readonly property var locale: Qt.locale("de_DE")

    // month shown in the calendar
    property int month: clock.date.getMonth()
    property int year: clock.date.getFullYear()

    function shiftMonth(delta: int): void {
        const d = new Date(year, month + delta, 1);
        month = d.getMonth();
        year = d.getFullYear();
    }

    kind: "clock"
    popupWidth: 290
    icon: Icons.clock
    text: Qt.formatTime(clock.date, "HH:mm")

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // back to the current month every time the popup opens
    Connections {
        target: root.popup
        function onOpenChanged() {
            if (!root.popup.open) return;
            root.month = clock.date.getMonth();
            root.year = clock.date.getFullYear();
        }
    }

    // ---- popup ----
    StyledText {
        Layout.fillWidth: true
        text: clock.date.toLocaleDateString(root.locale, "dddd, d. MMMM yyyy")
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
    }

    RowLayout {
        Layout.fillWidth: true

        IconButton { icon: "go-previous-symbolic"; iconSize: 16; showBackground: false; onClicked: root.shiftMonth(-1) }

        StyledText {
            Layout.fillWidth: true
            text: root.locale.standaloneMonthName(root.month) + " " + root.year
            horizontalAlignment: Text.AlignHCenter
            color: Theme.subtext0
        }

        IconButton { icon: "go-next-symbolic"; iconSize: 16; showBackground: false; onClicked: root.shiftMonth(1) }
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: 4
        rowSpacing: 0

        Item { implicitWidth: 1; implicitHeight: 1 }

        DayOfWeekRow {
            Layout.fillWidth: true
            locale: root.locale
            delegate: StyledText {
                required property string shortName
                text: shortName
                horizontalAlignment: Text.AlignHCenter
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize
            }
        }

        WeekNumberColumn {
            Layout.fillHeight: true
            month: root.month
            year: root.year
            locale: root.locale
            delegate: StyledText {
                required property int weekNumber
                text: weekNumber
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Theme.overlay0
                font.pixelSize: Theme.smallFontSize - 1
            }
        }

        MonthGrid {
            id: grid
            Layout.fillWidth: true
            month: root.month
            year: root.year
            locale: root.locale
            spacing: 2

            delegate: Rectangle {
                required property int day
                required property int month
                required property bool today

                implicitWidth: 30
                implicitHeight: 28
                radius: 6
                color: today ? Theme.accent : "transparent"

                StyledText {
                    anchors.centerIn: parent
                    text: parent.day
                    font.pixelSize: Theme.smallFontSize + 1
                    font.bold: parent.today
                    color: parent.today ? Theme.base : parent.month === grid.month ? Theme.text : Theme.overlay0
                }
            }

            WheelHandler {
                onWheel: (event) => root.shiftMonth(event.angleDelta.y > 0 ? -1 : 1)
            }
        }
    }

    ActionButton {
        Layout.alignment: Qt.AlignRight
        icon: "x-office-calendar-symbolic"
        text: "GNOME Calendar"
        onClicked: Quickshell.execDetached(["gnome-calendar"])
    }
}
