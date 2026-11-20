import QtQuick

// fills its parent, with hover and the hand cursor
MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
}
