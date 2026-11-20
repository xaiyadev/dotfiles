pragma ComponentBehavior: Bound

import QtQuick

// list of devices to pick one from (outputs, microphones, ...), closes after picking
SubPopup {
    id: root

    property var devices: []
    property var current: null
    property string itemIcon: ""
    signal selected(var device)

    Repeater {
        model: root.devices
        ListItem {
            required property var modelData
            icon: root.itemIcon
            text: modelData.description || modelData.name
            active: modelData === root.current
            onClicked: {
                root.selected(modelData);
                root.close();
            }
        }
    }
}