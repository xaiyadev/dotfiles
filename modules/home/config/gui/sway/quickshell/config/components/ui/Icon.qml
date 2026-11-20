import QtQuick
import qs.data

// material symbols icon; `icon` is the name of the symbol (fonts.google.com/icons), the font
// turns it into the glyph. way cheaper than recoloring theme icons with an effect each
Item {
    id: root

    property string icon: ""
    property int size: Theme.iconSize
    property alias color: glyph.color
    // filled version of the symbol, e.g. for something thats on
    property bool filled: false

    implicitWidth: size
    implicitHeight: size

    Text {
        id: glyph
        anchors.centerIn: parent
        text: root.icon
        color: Theme.text
        font.family: Theme.iconFont
        font.pixelSize: root.size
        // opsz only goes from 20 to 48
        font.variableAxes: ({ FILL: root.filled ? 1 : 0, opsz: Math.max(20, Math.min(48, root.size)) })
    }
}
