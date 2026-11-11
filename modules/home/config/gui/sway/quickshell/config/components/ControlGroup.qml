import QtQuick
import QtQuick.Layouts

// Audio, network and bluetooth, grouped a bit closer together
RowLayout {
    spacing: 16

    Volume { }
    NetworkIndicator { }
    BluetoothIndicator { }
}
