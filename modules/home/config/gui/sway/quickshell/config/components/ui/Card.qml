import QtQuick
import QtQuick.Layouts
import qs.data

// rounded panel with a border; children go into a ColumnLayout with `padding` around it
Rectangle {
    id: root

    default property alias content: inner.data
    property int padding: 16
    property alias spacing: inner.spacing

    implicitHeight: inner.implicitHeight + 2 * padding
    radius: Theme.radius
    color: Theme.base
    border { width: 1; color: Theme.surface0 }

    ColumnLayout {
        id: inner
        anchors { top: parent.top; left: parent.left; right: parent.right; margins: root.padding }
        spacing: 10
    }
}