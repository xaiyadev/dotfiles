import QtQuick

import "../data"

Item {
    id: root

    Text {
        anchors.centerIn: parent
        color: "#cdd6f4"
        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 15
        }

        text: Time.time
    }
}
