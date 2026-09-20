import QtQuick

import "../data"

Item {
    id: root

    Text {
        anchors.centerIn: parent
        color: "#cdd6f4"
        font.pixelSize: 14

        text: "󱑅  " + Time.time
    }
}
