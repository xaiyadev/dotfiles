import QtQuick
import Quickshell.Widgets
import qs.data

// rounded image with a fallback icon until it is loaded (avatar, cover art, notification image)
ClippingRectangle {
    id: root

    property alias source: image.source
    property string fallbackIcon: ""
    property int fallbackSize: Theme.smallIconSize

    radius: Theme.mediumRadius
    color: Theme.surface0

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        // twice the size so it stays sharp on scaled screens
        sourceSize { width: root.width * 2; height: root.height * 2 }
    }

    Icon {
        anchors.centerIn: parent
        visible: root.fallbackIcon !== "" && image.status !== Image.Ready
        icon: root.fallbackIcon
        size: root.fallbackSize
    }
}
