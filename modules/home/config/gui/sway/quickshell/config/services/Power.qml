pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

import "../data"

// battery state from upower, scaled to the charge limit (Config.chargeLimit)
Singleton {
    readonly property var device: UPower.devices.values.find(d => d.isLaptopBattery) ?? UPower.displayDevice
    readonly property bool present: device?.isPresent ?? false

    readonly property int percent: Math.min(100, Math.round((device?.percentage ?? 0) * 100 / Config.chargeLimit * 100))
    readonly property bool charging: device?.state === UPowerDeviceState.Charging
}
