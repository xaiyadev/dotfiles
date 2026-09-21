import QtQuick

import "../data"

Item {
    id: root

    implicitWidth: clockText.implicitWidth
    implicitHeight: clockText.implicitHeight

    Text {
        id: clockText
        anchors.centerIn: parent
        color: "#cdd6f4"
        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 15
        }

        text: Time.time
    }
}
