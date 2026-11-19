import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../../services"
import "../../data"
import "../ui"

// quick settings (user, tiles, volume) with the notifications and media cards below it
BarPopup {
    id: popup

    property string systemName: ""
    readonly property string userName: Quickshell.env("USER") ?? ""
    readonly property var subPopups: [sinkPicker, sourcePicker, wifiMenu, btMenu]

    cardWidth: 480
    // also checks visible, a HoverHandler can stay hovered after its window is gone
    extraHovered: subPopups.some(p => p.visible && p.hovered)
    // media card only while there is something to show; goes through a bool so switching
    // between two players doesnt rebuild the cards (and reset the notification scroll)
    readonly property bool hasPlayer: Mpris.selectedPlayer !== null
    cards: hasPlayer ? [notificationsCard, mediaCard] : [notificationsCard]

    // the menus are their own windows, so they have to be closed along with us
    onOpenChanged: if (!open) subPopups.forEach(p => p.close())

    // only one menu at a time, they would overlap otherwise
    function toggleMenu(menu, item: Item): void {
        subPopups.forEach(p => { if (p !== menu) p.close(); });
        menu.toggleBelow(item);
    }

    FileView {
        path: "/etc/hostname"
        onLoaded: popup.systemName = text().trim()
    }

    Component { id: notificationsCard; NotificationPanel {} }
    Component { id: mediaCard; MediaPanel {} }

    // header
    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        ImageTile {
            implicitWidth: 28
            implicitHeight: 28
            radius: height / 2
            fallbackIcon: "person"
            source: {
                // d=404 so a missing avatar fails and we show the icon instead of gravatars default
                const hash = Config.avatars[popup.userName] ?? "";
                return hash ? "https://www.gravatar.com/avatar/" + hash + "?s=56&d=404" : "";
            }
        }

        StyledText {
            text: [popup.userName, popup.systemName].filter(s => s).join("@") || "…"
            font.bold: true
        }

        Item { Layout.fillWidth: true }

        Battery { fontSize: Theme.smallFontSize }
    }

    Separator { }

    // tiles; click toggles, the arrow (or right click) opens the menu below it
    GridLayout {
        Layout.fillWidth: true
        columns: 2
        uniformCellWidths: true
        rowSpacing: 8
        columnSpacing: 8

        ToggleTile {
            id: wifiTile
            icon: Network.wifiEnabled ? Network.wifiIcon(Network.activeWifi?.signalStrength ?? 1) : "signal_wifi_off"
            title: "Wi-Fi"
            subtitle: Network.activeWifi?.name
                ?? (Network.wiredDevice !== null ? "Ethernet" : (Network.wifiEnabled ? "Not connected" : "Off"))
            active: Network.wifiEnabled
            hasMenu: true
            enabled: Network.wifiDevice !== null
            onClicked: Network.setWifiEnabled(!Network.wifiEnabled)
            onMenuRequested: popup.toggleMenu(wifiMenu, wifiTile)
        }

        ToggleTile {
            id: btTile
            icon: Bluetooth.enabled ? "bluetooth" : "bluetooth_disabled"
            title: "Bluetooth"
            subtitle: Bluetooth.connected.length > 0
                ? Bluetooth.connected.length + (Bluetooth.connected.length === 1 ? " device" : " devices")
                : (Bluetooth.enabled ? "No devices" : "Off")
            active: Bluetooth.enabled
            hasMenu: true
            enabled: Bluetooth.adapter !== null
            onClicked: Bluetooth.setEnabled(!Bluetooth.enabled)
            onMenuRequested: popup.toggleMenu(btMenu, btTile)
        }

        ToggleTile {
            icon: "notifications_off"
            title: "Silent"
            active: Notifications.doNotDisturb
            onClicked: Notifications.doNotDisturb = !Notifications.doNotDisturb
        }

        ToggleTile {
            icon: "coffee"
            title: "Awake"
            active: IdleInhibit.enabled
            onClicked: IdleInhibit.enabled = !IdleInhibit.enabled
        }
    }

    Separator { }

    // volume and microphone
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 1

        VolumeRow {
            id: sinkRow
            icon: Pipewire.sinkIcon
            value: Pipewire.sinkVolume
            showPicker: Pipewire.sinks.length > 1
            pickerOpen: sinkPicker.visible
            onMoved: (value) => Pipewire.setVolume(Pipewire.sink, value)
            onMuteClicked: Pipewire.toggleMute(Pipewire.sink)
            onPickerClicked: popup.toggleMenu(sinkPicker, sinkRow.pickerButton)
        }

        VolumeRow {
            id: sourceRow
            icon: Pipewire.sourceIcon
            value: Pipewire.sourceVolume
            showPicker: Pipewire.sources.length > 1
            pickerOpen: sourcePicker.visible
            onMoved: (value) => Pipewire.setVolume(Pipewire.source, value)
            onMuteClicked: Pipewire.toggleMute(Pipewire.source)
            onPickerClicked: popup.toggleMenu(sourcePicker, sourceRow.pickerButton)
        }
    }

    // menus opened from the tiles and volume rows
    WifiMenu { id: wifiMenu; anchor.window: popup }
    BluetoothMenu { id: btMenu; anchor.window: popup }

    DevicePicker {
        id: sinkPicker
        anchor.window: popup
        devices: Pipewire.sinks
        current: Pipewire.sink
        itemIcon: "volume_up"
        onSelected: (device) => Pipewire.setDefaultSink(device)
    }

    DevicePicker {
        id: sourcePicker
        anchor.window: popup
        devices: Pipewire.sources
        current: Pipewire.source
        itemIcon: "mic"
        onSelected: (device) => Pipewire.setDefaultSource(device)
    }
}