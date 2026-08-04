import QtQuick

import "../data"

Item {
    id: root

    Text {
        anchors.centerIn: parent
        color: "#cdd6f4"
        font.pixelSize: 14
        opacity: 0.8

        text: "󱑅  " + Time.time
    }
}
