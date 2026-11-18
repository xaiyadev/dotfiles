import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Bluetooth as QsBluetooth
import "../services"
import "../data"
import "ui"

// Audio, network, bluetooth, notifications and battery merged into one bar pill.
Item {
    id: root

    property var passwordTarget: null
    property string systemName: ""
    property string userName: ""

    Process {
        running: true
        command: ["hostname"]
        stdout: StdioCollector {
            onStreamFinished: root.systemName = this.text.trim()
        }
    }

    Process {
        running: true
        command: ["whoami"]
        stdout: StdioCollector {
            onStreamFinished: root.userName = this.text.trim()
        }
    }

    Connections {
        target: popup
        function onOpenChanged() {
            root.passwordTarget = null;
            if (!popup.open) {
                devicePickerWindow.closePicker();
                sourcePickerWindow.closePicker();
                wifiOptionsWindow.closePicker();
                btOptionsWindow.closePicker();
            }
        }
    }

    implicitWidth: row.implicitWidth
    implicitHeight: 20

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 10

        // volume
        Item {
            implicitWidth: Theme.iconSize
            implicitHeight: Theme.iconSize
            Icon { anchors.fill: parent; icon: Pipewire.sinkIcon; color: Theme.subtext0 }
        }

        // network (dot = VPN active)
        Item {
            implicitWidth: Theme.iconSize
            implicitHeight: Theme.iconSize
            Icon { anchors.fill: parent; icon: Network.icon; color: Theme.subtext0 }
        }

        // notification bell (dot = unread)
        Item {
            id: bellItem
            implicitWidth: Theme.iconSize
            implicitHeight: Theme.iconSize
            Layout.leftMargin: 6
            Icon { anchors.fill: parent; icon: Notifications.doNotDisturb ? Icons.bellOff : Icons.bell; color: Theme.text }
            Rectangle {
                visible: Notifications.count > 0 && !Notifications.doNotDisturb
                anchors { right: parent.right; bottom: parent.bottom; rightMargin: -3; bottomMargin: -2 }
                width: 8; height: 8; radius: 4
                color: Theme.accent
                border { width: 2; color: Theme.base }
            }
        }

        // battery (dot = keep awake on)
        Item {
            visible: Power.present
            implicitWidth: Theme.iconSize
            implicitHeight: Theme.iconSize
            BatteryIcon {
                anchors.fill: parent
                level: Power.percent / 100
                charging: Power.charging
                color: Power.levelColor
            }
        }

        StyledText {
            visible: Power.present
            text: Power.percent + "%"
            color: Power.levelColor
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onClicked: (event) => {
            if (event.button === Qt.MiddleButton) {
                if (Mpris.selectedPlayer?.canTogglePlaying) Mpris.selectedPlayer.togglePlaying();
            } else {
                popup.toggle();
            }
        }
        onWheel: (event) => Pipewire.setSinkVolume(Pipewire.sinkVolume + (event.angleDelta.y > 0 ? 0.02 : -0.02))
        onContainsMouseChanged: {
            if (containsMouse && Popups.current !== null && !popup.open) popup.toggle();
        }
    }

    BarPopup {
        id: popup
        trigger: root
        triggerHovered: mouse.containsMouse
        extraHovered: devicePickerWindow.visible || devicePickerWindow.shown ||
                      wifiOptionsWindow.visible || wifiOptionsWindow.shown ||
                      btOptionsWindow.visible || btOptionsWindow.shown ||
                      sourcePickerWindow.visible || sourcePickerWindow.shown
        kind: "controls"
        cardWidth: 480
        belowComponent: notifComp
        below2Component: mediaComp

        // ── Header ───────────────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ClippingRectangle {
                implicitWidth: 28
                implicitHeight: 28
                radius: 14
                color: Theme.surface0

                Image {
                    id: pfp
                    anchors.fill: parent
                    source: {
                        const hashes = {
                            "xaiya":   "3c840e20aedb665ac4a8b5d1daaf8fd9",
                            "blmedia": "6d8aebedc2d80c49e6f1e86a2e9e0c1f"
                        };
                        const hash = hashes[root.userName] ?? "";
                        return hash ? "https://www.gravatar.com/avatar/" + hash + "?s=56&d=404" : "";
                    }
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }

                Icon {
                    anchors.centerIn: parent
                    visible: pfp.status !== Image.Ready
                    icon: "avatar-default-symbolic"
                    size: 16
                }
            }

            StyledText {
                text: (root.userName && root.systemName) ? root.userName + "@" + root.systemName : (root.userName || root.systemName || "…")
                font.bold: true
                font.pixelSize: Theme.fontSize
                color: Theme.text
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                visible: Power.present
                spacing: 6

                Item {
                    implicitWidth: Theme.iconSize
                    implicitHeight: Theme.iconSize
                    BatteryIcon {
                        anchors.fill: parent
                        level: Power.percent / 100
                        charging: Power.charging
                        color: Power.levelColor
                    }
                }

                StyledText {
                    text: Power.percent + "%"
                    color: Power.levelColor
                    font.pixelSize: Theme.smallFontSize
                }
            }
        }

        Separator { }

        // ── Tiles: WiFi + Bluetooth / DND + Keep awake ───────────────────────
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // WiFi
                Rectangle {
                    id: wifiTile
                    Layout.fillWidth: true
                    implicitHeight: 46
                    radius: Theme.radius
                    color: Network.wifiEnabled ? Theme.surface1 : Theme.surface0
                    border { width: 1; color: Theme.surface1 }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (event) => {
                            if (event.button === Qt.RightButton) {
                                if (!wifiOptionsWindow.shown) {
                                    const pos = wifiTile.mapToItem(popup.contentItem, 0, wifiTile.height + 4);
                                    wifiOptionsWindow.anchor.rect.x = Math.round(pos.x);
                                    wifiOptionsWindow.anchor.rect.y = Math.round(pos.y);
                                    wifiOptionsWindow.openPicker();
                                } else {
                                    wifiOptionsWindow.closePicker();
                                }
                            } else if (Network.wifiDevice) {
                                Network.setWifiEnabled(!Network.wifiEnabled);
                            }
                        }
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                        spacing: 10

                        Icon {
                            icon: Icons.wifi(Network.wifiEnabled ? 1 : 0)
                            size: 16
                            color: Network.wifiEnabled ? Theme.accent : Theme.subtext0
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            StyledText {
                                text: "Wi-Fi"
                                font.bold: true
                                font.pixelSize: Theme.smallFontSize
                                color: Network.wifiEnabled ? Theme.text : Theme.subtext0
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }

                            StyledText {
                                Layout.fillWidth: true
                                text: Network.activeWifi?.name
                                    ?? (Network.wiredDevice !== null ? "Ethernet" : (Network.wifiEnabled ? "Not connected" : "Off"))
                                color: Theme.subtext0
                                font.pixelSize: Theme.smallFontSize
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                // Bluetooth
                Rectangle {
                    id: btTile
                    Layout.fillWidth: true
                    implicitHeight: 46
                    radius: Theme.radius
                    color: Bluetooth.enabled ? Theme.surface1 : Theme.surface0
                    border { width: 1; color: Theme.surface1 }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (event) => {
                            if (event.button === Qt.RightButton) {
                                if (!btOptionsWindow.shown) {
                                    const pos = btTile.mapToItem(popup.contentItem, 0, btTile.height + 4);
                                    btOptionsWindow.anchor.rect.x = Math.round(pos.x);
                                    btOptionsWindow.anchor.rect.y = Math.round(pos.y);
                                    btOptionsWindow.openPicker();
                                } else {
                                    btOptionsWindow.closePicker();
                                }
                            } else if (Bluetooth.adapter) {
                                Bluetooth.setEnabled(!Bluetooth.enabled);
                            }
                        }
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                        spacing: 10

                        Icon {
                            icon: Icons.bluetooth
                            size: 16
                            color: Bluetooth.enabled ? Theme.accent : Theme.subtext0
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            StyledText {
                                text: "Bluetooth"
                                font.bold: true
                                font.pixelSize: Theme.smallFontSize
                                color: Bluetooth.enabled ? Theme.text : Theme.subtext0
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }

                            StyledText {
                                text: Bluetooth.connected.length > 0
                                    ? Bluetooth.connected.length + (Bluetooth.connected.length === 1 ? " device" : " devices")
                                    : (Bluetooth.enabled ? "No devices" : "Off")
                                color: Theme.subtext0
                                font.pixelSize: Theme.smallFontSize
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // Do Not Disturb
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 46
                    radius: Theme.radius
                    color: Notifications.doNotDisturb ? Theme.surface1 : Theme.surface0
                    border { width: 1; color: Theme.surface1 }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Notifications.doNotDisturb = !Notifications.doNotDisturb
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                        spacing: 10

                        Icon {
                            icon: Icons.bellOff
                            size: 16
                            color: Notifications.doNotDisturb ? Theme.accent : Theme.subtext0
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            StyledText {
                                text: "Silent"
                                font.bold: true
                                font.pixelSize: Theme.smallFontSize
                                color: Notifications.doNotDisturb ? Theme.text : Theme.subtext0
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }

                            StyledText {
                                text: Notifications.doNotDisturb ? "On" : "Off"
                                color: Theme.subtext0
                                font.pixelSize: Theme.smallFontSize
                            }
                        }
                    }
                }

                // Keep Awake
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 46
                    radius: Theme.radius
                    color: IdleInhibit.enabled ? Theme.surface1 : Theme.surface0
                    border { width: 1; color: Theme.surface1 }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: IdleInhibit.toggle()
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                        spacing: 10

                        Icon {
                            icon: Icons.eye
                            size: 16
                            color: IdleInhibit.enabled ? Theme.accent : Theme.subtext0
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            StyledText {
                                text: "Awake"
                                font.bold: true
                                font.pixelSize: Theme.smallFontSize
                                color: IdleInhibit.enabled ? Theme.text : Theme.subtext0
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }

                            StyledText {
                                text: IdleInhibit.enabled ? "On" : "Off"
                                color: Theme.subtext0
                                font.pixelSize: Theme.smallFontSize
                            }
                        }
                    }
                }
            }

        }

        Separator { }

        // ── Volume + Microphone rows ──────────────────────────────────────────
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Icon {
                icon: Pipewire.sinkIcon
                size: 16
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Pipewire.toggleSinkMute()
                }
            }

            Slider {
                Layout.fillWidth: true
                value: Pipewire.sinkVolume
                onMoved: (value) => Pipewire.setSinkVolume(value)
            }

            StyledText {
                Layout.preferredWidth: 36
                text: Pipewire.sinkVolumeText
                color: Theme.subtext0
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.smallFontSize
            }

            IconButton {
                id: deviceBtn
                visible: Pipewire.sinks.length > 1
                icon: "audio-card-symbolic"
                selected: devicePickerWindow.visible
                onClicked: {
                    if (!devicePickerWindow.shown) {
                        const pos = deviceBtn.mapToItem(popup.contentItem, 0, deviceBtn.height + 4);
                        devicePickerWindow.anchor.rect.x = Math.round(pos.x);
                        devicePickerWindow.anchor.rect.y = Math.round(pos.y);
                        devicePickerWindow.openPicker();
                    } else {
                        devicePickerWindow.closePicker();
                    }
                }
            }

        }

        // ── Microphone row ────────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Icon {
                icon: Pipewire.sourceIcon
                size: 16
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Pipewire.toggleSourceMute()
                }
            }

            Slider {
                Layout.fillWidth: true
                value: Pipewire.sourceVolume
                onMoved: (value) => Pipewire.setSourceVolume(value)
            }

            StyledText {
                Layout.preferredWidth: 36
                text: Pipewire.sourceVolumeText
                color: Theme.subtext0
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.smallFontSize
            }

            IconButton {
                id: sourceBtn
                visible: Pipewire.sources.length > 1
                icon: "audio-card-symbolic"
                selected: sourcePickerWindow.visible
                onClicked: {
                    if (!sourcePickerWindow.shown) {
                        const pos = sourceBtn.mapToItem(popup.contentItem, 0, sourceBtn.height + 4);
                        sourcePickerWindow.anchor.rect.x = Math.round(pos.x);
                        sourcePickerWindow.anchor.rect.y = Math.round(pos.y);
                        sourcePickerWindow.openPicker();
                    } else {
                        sourcePickerWindow.closePicker();
                    }
                }
            }

        }
    }


    Component {
        id: mediaComp
        MediaPanel {}
    }

    Component {
        id: notifComp

        ColumnLayout {
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 4

                Icon {
                    icon: Icons.bell
                    size: 16
                    color: Theme.text
                }

                StyledText {
                    text: "Notifications"
                    font.bold: true
                    font.pixelSize: Theme.fontSize
                    color: Theme.text
                }

                Item { Layout.fillWidth: true }

                IconButton {
                    visible: Notifications.count > 0
                    icon: "edit-clear-all-symbolic"
                    iconSize: 14
                    showBackground: false
                    iconColor: Theme.subtext0
                    onClicked: Notifications.clearAll()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.surface1
            }

            StyledText {
                Layout.fillWidth: true
                Layout.topMargin: 4
                Layout.bottomMargin: 4
                visible: Notifications.count === 0
                text: "No notifications"
                color: Theme.overlay0
                horizontalAlignment: Text.AlignHCenter
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(notifList.implicitHeight, 240)
                visible: Notifications.count > 0
                contentWidth: availableWidth
                clip: true
                focusPolicy: Qt.NoFocus

                ColumnLayout {
                    id: notifList
                    width: parent.width
                    spacing: 8

                    Repeater {
                        model: ScriptModel { values: [...Notifications.history] }
                        NotificationCard {
                            required property var modelData
                            notification: modelData
                        }
                    }
                }
            }

        }
    }

    // WiFi network list popup (right-click on WiFi tile)
    PopupWindow {
        id: wifiOptionsWindow
        parentWindow: popup
        visible: false
        color: "transparent"
        implicitWidth: 300
        implicitHeight: wifiOptionsList.implicitHeight + 16

        property bool shown: false

        function openPicker(): void {
            shown = false;
            visible = true;
            Qt.callLater(() => { shown = true; });
        }

        function closePicker(): void { shown = false; }

        Rectangle {
            anchors.fill: parent
            color: Theme.base
            border { width: 1; color: Theme.surface0 }
            radius: Theme.radius

            opacity: wifiOptionsWindow.shown ? 1 : 0
            y: wifiOptionsWindow.shown ? 0 : -6

            Behavior on opacity {
                NumberAnimation {
                    duration: 150; easing.type: Easing.OutCubic
                    onRunningChanged: if (!running && !wifiOptionsWindow.shown) wifiOptionsWindow.visible = false
                }
            }
            Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            ColumnLayout {
                id: wifiOptionsList
                anchors { fill: parent; margins: 8 }
                spacing: 2

                StyledText {
                    visible: !Network.wifiEnabled
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 4; Layout.bottomMargin: 4
                    text: "Wi-Fi is off"
                    color: Theme.overlay0
                    font.pixelSize: Theme.smallFontSize
                }

                Repeater {
                    model: ScriptModel { values: Network.wifiEnabled ? Network.networks.slice(0, 7) : [] }

                    ColumnLayout {
                        id: wifiEntry
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 2

                        ListItem {
                            icon: Icons.wifi(wifiEntry.modelData.signalStrength)
                            text: wifiEntry.modelData.name
                            active: wifiEntry.modelData.connected
                            subtext: wifiEntry.modelData.stateChanging ? "Connecting…"
                                : wifiEntry.modelData.connected ? "Connected"
                                : wifiEntry.modelData.known ? "Saved" : ""
                            trailingIcon: Network.isSecured(wifiEntry.modelData) ? Icons.lock : ""
                            onClicked: {
                                const n = wifiEntry.modelData;
                                if (n.connected) n.disconnect();
                                else if (n.known || !Network.isSecured(n)) n.connect();
                                else root.passwordTarget = root.passwordTarget === n ? null : n;
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            visible: root.passwordTarget === wifiEntry.modelData
                            implicitHeight: 30
                            radius: 8
                            color: Theme.surface0

                            TextInput {
                                id: wifiPwd
                                anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                                verticalAlignment: TextInput.AlignVCenter
                                echoMode: TextInput.Password
                                color: Theme.text
                                font.family: Theme.font
                                font.pixelSize: Theme.smallFontSize + 1
                                clip: true
                                focus: parent.visible
                                onAccepted: {
                                    wifiEntry.modelData.connectWithPsk(text);
                                    text = "";
                                    root.passwordTarget = null;
                                }
                                StyledText {
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: wifiPwd.text === ""
                                    text: "Password, Enter to connect"
                                    color: Theme.overlay0
                                    font.pixelSize: Theme.smallFontSize
                                }
                            }
                        }
                    }
                }

                ActionButton {
                    Layout.alignment: Qt.AlignRight
                    Layout.topMargin: 4
                    icon: "preferences-system-symbolic"
                    text: "Network settings"
                    onClicked: Quickshell.execDetached(["nm-connection-editor"])
                }
            }
        }
    }

    // Bluetooth device list popup (right-click on Bluetooth tile)
    PopupWindow {
        id: btOptionsWindow
        parentWindow: popup
        visible: false
        color: "transparent"
        implicitWidth: 260
        implicitHeight: btOptionsList.implicitHeight + 16

        property bool shown: false

        function openPicker(): void {
            shown = false;
            visible = true;
            Qt.callLater(() => { shown = true; });
        }

        function closePicker(): void { shown = false; }

        Rectangle {
            anchors.fill: parent
            color: Theme.base
            border { width: 1; color: Theme.surface0 }
            radius: Theme.radius

            opacity: btOptionsWindow.shown ? 1 : 0
            y: btOptionsWindow.shown ? 0 : -6

            Behavior on opacity {
                NumberAnimation {
                    duration: 150; easing.type: Easing.OutCubic
                    onRunningChanged: if (!running && !btOptionsWindow.shown) btOptionsWindow.visible = false
                }
            }
            Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            ColumnLayout {
                id: btOptionsList
                anchors { fill: parent; margins: 8 }
                spacing: 2

                StyledText {
                    visible: !Bluetooth.enabled
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 4; Layout.bottomMargin: 4
                    text: "Bluetooth is off"
                    color: Theme.overlay0
                    font.pixelSize: Theme.smallFontSize
                }

                Repeater {
                    model: ScriptModel { values: Bluetooth.enabled ? Bluetooth.devices : [] }
                    ListItem {
                        required property var modelData
                        icon: (modelData.icon || "bluetooth") + "-symbolic"
                        text: modelData.name
                        active: modelData.connected
                        subtext: modelData.connected ? "Connected" : (modelData.paired ? "Paired" : "")
                        onClicked: Bluetooth.toggleConnection(modelData)
                    }
                }

                StyledText {
                    visible: Bluetooth.enabled && Bluetooth.devices.length === 0
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 4; Layout.bottomMargin: 4
                    text: "No paired devices"
                    color: Theme.overlay0
                    font.pixelSize: Theme.smallFontSize
                }

                ActionButton {
                    Layout.alignment: Qt.AlignRight
                    Layout.topMargin: 4
                    icon: "preferences-system-symbolic"
                    text: "Bluetooth settings"
                    onClicked: Quickshell.execDetached(["overskride"])
                }
            }
        }
    }

    // Microphone input device selection popup
    PopupWindow {
        id: sourcePickerWindow
        parentWindow: popup
        visible: false
        color: "transparent"
        implicitWidth: 240
        implicitHeight: sourceList.implicitHeight + 16

        property bool shown: false

        function openPicker(): void {
            shown = false;
            visible = true;
            Qt.callLater(() => { shown = true; });
        }

        function closePicker(): void { shown = false; }

        Rectangle {
            anchors.fill: parent
            color: Theme.base
            border { width: 1; color: Theme.surface0 }
            radius: Theme.radius

            opacity: sourcePickerWindow.shown ? 1 : 0
            y: sourcePickerWindow.shown ? 0 : -6

            Behavior on opacity {
                NumberAnimation {
                    duration: 150; easing.type: Easing.OutCubic
                    onRunningChanged: if (!running && !sourcePickerWindow.shown) sourcePickerWindow.visible = false
                }
            }
            Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            ColumnLayout {
                id: sourceList
                anchors { fill: parent; margins: 8 }
                spacing: 2

                Repeater {
                    model: Pipewire.sources
                    ListItem {
                        required property var modelData
                        icon: "audio-input-microphone-symbolic"
                        text: modelData.description || modelData.name
                        active: modelData === Pipewire.source
                        onClicked: {
                            Pipewire.setDefaultSource(modelData);
                            sourcePickerWindow.closePicker();
                        }
                    }
                }
            }
        }
    }

    // Separate popup for audio output device selection
    PopupWindow {
        id: devicePickerWindow
        parentWindow: popup
        visible: false
        color: "transparent"
        implicitWidth: 240
        implicitHeight: deviceList.implicitHeight + 16

        property bool shown: false

        function openPicker(): void {
            shown = false;
            visible = true;
            Qt.callLater(() => { shown = true; });
        }

        function closePicker(): void {
            shown = false;
        }

        Rectangle {
            id: card
            anchors.fill: parent
            color: Theme.base
            border { width: 1; color: Theme.surface0 }
            radius: Theme.radius

            opacity: devicePickerWindow.shown ? 1 : 0
            y: devicePickerWindow.shown ? 0 : -6

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                    onRunningChanged: if (!running && !devicePickerWindow.shown) devicePickerWindow.visible = false
                }
            }
            Behavior on y { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            ColumnLayout {
                id: deviceList
                anchors { fill: parent; margins: 8 }
                spacing: 2

                Repeater {
                    model: Pipewire.sinks
                    ListItem {
                        required property var modelData
                        icon: Icons.volume(1, false)
                        text: modelData.description || modelData.name
                        active: modelData === Pipewire.sink
                        onClicked: {
                            Pipewire.setDefaultSink(modelData);
                            devicePickerWindow.closePicker();
                        }
                    }
                }
            }
        }
    }
}
}
