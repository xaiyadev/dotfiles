pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

import '../data'

// Battery state via UPower.
Singleton {
    id: root

    readonly property var device: UPower.devices.values.find(d => d.isLaptopBattery) ?? UPower.displayDevice
    readonly property bool present: device?.isPresent ?? false

    readonly property real rawPercent: (device?.percentage ?? 0) * 100
    readonly property int fullAt: 80
    readonly property int percent: Math.min(100, Math.round(rawPercent / fullAt * 100))

    readonly property bool onBattery: UPower.onBattery
    readonly property bool charging: device?.state === UPowerDeviceState.Charging

    readonly property string level: percent <= 20 ? "critical" : percent <= 30 ? "warning" : "normal"
    readonly property color levelColor: level === "critical" ? Theme.red : level === "warning" ? Theme.rosewater : Theme.text

    readonly property bool full: !onBattery && !charging && percent >= 99
}
