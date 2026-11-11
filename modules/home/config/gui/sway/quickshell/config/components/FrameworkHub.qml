import QtQuick
import QtQuick.Layouts
import "../services"
import "../data"
import "ui"

// Framework hub. Bar: laptop (on AC, full) or battery level + percentage, the charge limit counts
// as full. Popup: power profile (tuned), tabs battery details & wear, USB-C power delivery
// ports, fan, system (CPU, memory, temperatures), privacy (switches, camera / microphone in use),
// hardware (framework_tool: expansion bay, input modules, firmware).
BarModule {
    id: root

    property string tab: "Battery"

    // short summary of what a profile changes (CPU boost, fan strategy), e.g. "no boost · almost-silent"
    function profileSummary(id: string): string {
        const d = Power.profileDetails[id];
        if (!d) return "";
        const parts = [];
        if (d.boost !== undefined) parts.push(d.boost === "1" ? "boost" : "no boost");
        if (d.fan) parts.push(d.fan);
        return parts.join(" · ");
    }

    kind: "framework"
    visible: Power.present
    // drawn battery; when plugged in at the charge limit a laptop instead
    icon: Power.full ? Icons.laptop : ""
    iconDelegate: Power.full ? null : batteryIcon
    text: Power.barText
    color: Power.levelColor
    // dot while the microphone or camera is in use and its privacy switch is on (details: Privacy tab)
    badge: (Privacy.micActive && FrameworkTool.micSwitchOn) || (Privacy.cameraActive && FrameworkTool.cameraSwitchOn)
    popupWidth: 360

    // always start on the battery tab
    Connections {
        target: root.popup
        function onOpenChanged() { if (root.popup.open) root.tab = "Battery"; }
    }

    // EC live data (framework_tool) only for the tabs that show it
    Binding {
        target: FrameworkTool
        property: "liveWanted"
        value: ["Fan", "System", "Privacy"].includes(root.tab)
        when: root.popup.open
    }

    Component {
        id: batteryIcon
        BatteryIcon {
            level: Power.percent / 100
            // no charging pulse in focus mode (it redraws the bar all the time)
            charging: Power.charging && !GameMode.active
            color: Power.levelColor
        }
    }

    // ---- popup ----
    PanelHeader {
        icon: Icons.laptop
        title: "Framework"
    }

    Separator { }

    // power profile
    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        Repeater {
            model: Power.profiles

            Rectangle {
                id: profileButton
                required property var modelData
                readonly property bool selected: Power.profile === modelData.id

                Layout.fillWidth: true
                implicitHeight: 46
                radius: 8
                color: selected ? Theme.accent : profileMouse.containsMouse ? Theme.surface0 : "transparent"
                border { width: 1; color: selected ? Theme.accent : Theme.surface0 }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 1

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 6

                        Icon {
                            icon: profileButton.modelData.icon
                            size: 14
                            color: profileButton.selected ? Theme.base : Theme.text
                        }

                        StyledText {
                            text: profileButton.modelData.label
                            color: profileButton.selected ? Theme.base : Theme.text
                            font.pixelSize: Theme.smallFontSize
                            font.bold: profileButton.selected
                        }
                    }

                    // what the profile changes
                    StyledText {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.maximumWidth: profileButton.width - 12
                        visible: text !== ""
                        text: root.profileSummary(profileButton.modelData.id)
                        color: profileButton.selected ? Theme.base : Theme.subtext0
                        opacity: profileButton.selected ? 0.75 : 1
                        font.pixelSize: Theme.smallFontSize - 2
                    }
                }

                MouseArea {
                    id: profileMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Power.setProfile(profileButton.modelData.id)
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 4

        Repeater {
            model: ["Battery", "System", "Ports"].concat(Power.fanAvailable ? ["Fan"] : [], ["Privacy"])

            Rectangle {
                id: tabButton
                required property string modelData

                // width = word + padding, the free space is shared equally -> same padding
                // for short and long words (bold width so selecting doesn't shift the tabs)
                Layout.fillWidth: true
                implicitWidth: tabWidth.width + 16
                implicitHeight: 26
                radius: 8
                color: root.tab === modelData ? Theme.surface1 : tabMouse.containsMouse ? Theme.surface0 : "transparent"

                TextMetrics {
                    id: tabWidth
                    text: tabButton.modelData
                    font.family: Theme.font
                    font.pixelSize: Theme.smallFontSize
                    font.bold: true
                }

                StyledText {
                    anchors.centerIn: parent
                    text: parent.modelData
                    font.pixelSize: Theme.smallFontSize
                    font.bold: root.tab === parent.modelData
                }

                MouseArea {
                    id: tabMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.tab = parent.modelData
                }
            }
        }

        // hardware details (rarely needed): small icon instead of a full tab
        IconButton {
            visible: FrameworkTool.available
            implicitWidth: 26
            radius: 8
            icon: "dialog-information-symbolic"
            selected: root.tab === "Hardware"
            iconColor: selected || hovered ? Theme.text : Theme.overlay0
            onClicked: root.tab = "Hardware"
        }
    }

    Separator { }

    // --- battery ---
    ColumnLayout {
        Layout.fillWidth: true
        visible: root.tab === "Battery"
        spacing: 4

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            BatteryIcon {
                implicitWidth: 26
                implicitHeight: 26
                level: Power.percent / 100
                charging: Power.charging
                color: Power.levelColor
            }

            StyledText {
                text: Power.percent + "%"
                color: Power.levelColor
                font.pixelSize: 22
                font.bold: true
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 6
            text: Power.statusText
            color: Theme.subtext0
            font.pixelSize: Theme.smallFontSize
        }

        InfoRow { label: "Charge"; value: Math.round(Power.rawPercent) + "% (limit " + Power.fullAt + "%)" }
        InfoRow { label: "Power"; value: Power.watts > 0.05 ? Power.watts.toFixed(1) + " W" : "" }
        InfoRow { label: Power.charging ? "Full in" : "Remaining"; value: Power.formatDuration(Power.secondsLeft) }
        InfoRow { label: "Cycles"; value: Power.cycles > 0 ? String(Power.cycles) : "" }
        InfoRow {
            label: "Capacity"
            value: Power.designWh > 0 ? Power.fullWh.toFixed(1) + " / " + Power.designWh.toFixed(1) + " Wh" : ""
        }
        InfoRow {
            label: "Health"
            value: Power.health > 0 ? Power.health.toFixed(1) + "% (" + (100 - Power.health).toFixed(1) + "% lost)" : ""
            valueColor: Power.health > 0 && Power.health < 70 ? Theme.peach : Theme.text
        }
    }

    // --- USB-C power delivery ---
    ColumnLayout {
        Layout.fillWidth: true
        visible: root.tab === "Ports"
        spacing: 2

        Repeater {
            model: Power.ports

            ListItem {
                required property var modelData
                interactive: false
                icon: modelData.online ? "battery-level-80-charging-symbolic" : "media-removable-symbolic"
                active: modelData.online
                text: modelData.name
                subtext: modelData.online
                    ? modelData.volts.toFixed(1) + " V  ·  " + modelData.amps.toFixed(1) + " A"
                    : "No charger"
                trailing: modelData.online ? Math.round(modelData.watts) + " W" : ""
            }
        }

        StyledText {
            visible: Power.ports.length === 0
            text: "No USB-C power info"
            color: Theme.subtext0
            font.pixelSize: Theme.smallFontSize
        }
    }

    // --- fan ---
    ColumnLayout {
        Layout.fillWidth: true
        visible: root.tab === "Fan"
        spacing: 4

        InfoRow { label: "Speed"; value: Power.fanSpeed + "%" }
        InfoRow { label: "Temperature"; value: Power.temperature.toFixed(1) + " °C" }
        InfoRow { label: "Strategy"; value: Power.fanStrategy }
        InfoRow {
            label: "Fans (EC)"
            value: FrameworkTool.leftFanRpm > 0 || FrameworkTool.rightFanRpm > 0
                ? "left " + FrameworkTool.leftFanRpm + " · right " + FrameworkTool.rightFanRpm + " RPM" : ""
        }
    }

    // --- system ---
    ColumnLayout {
        Layout.fillWidth: true
        visible: root.tab === "System"
        spacing: 4

        InfoRow { label: "CPU"; value: Math.round(SystemStats.cpuUsage * 100) + "%  ·  " + SystemStats.cpuTemp.toFixed(0) + " °C" }
        Meter { value: SystemStats.cpuUsage }
        InfoRow {
            label: "Memory"
            value: SystemStats.memUsedGiB.toFixed(1) + " / " + SystemStats.memTotalGiB.toFixed(1) + " GiB"
        }
        Meter { value: SystemStats.memTotalGiB > 0 ? SystemStats.memUsedGiB / SystemStats.memTotalGiB : 0 }
        InfoRow { label: "iGPU"; value: SystemStats.igpuTemp.toFixed(0) + " °C" }
        InfoRow {
            label: "dGPU"
            value: SystemStats.dgpuAwake ? SystemStats.dgpuTemp.toFixed(0) + " °C" : "sleeping"
            valueColor: SystemStats.dgpuAwake ? Theme.text : Theme.overlay0
        }
        InfoRow { label: "SSD"; value: SystemStats.nvmeTemp.toFixed(0) + " °C" }
        InfoRow {
            label: "Throttling"
            value: !FrameworkTool.available ? "" : FrameworkTool.hardThrottle ? "hard (PROCHOT)"
                : FrameworkTool.softThrottle ? "power limit" : "none"
            valueColor: FrameworkTool.hardThrottle || FrameworkTool.softThrottle ? Theme.peach : Theme.text
        }
    }

    // --- privacy: camera / microphone ---
    ColumnLayout {
        Layout.fillWidth: true
        visible: root.tab === "Privacy"
        spacing: 2

        ListItem {
            interactive: false
            icon: "camera-web-symbolic"
            text: "Camera"
            active: Privacy.cameraActive && FrameworkTool.cameraSwitchOn
            // switch position from the EC (framework_tool); without it: camera missing = switch off
            subtext: (FrameworkTool.available ? !FrameworkTool.cameraSwitchOn : !Privacy.cameraPresent) ? "Off (privacy switch)"
                : Privacy.cameraActive ? "In use by " + Privacy.cameraApps.join(", ")
                : "On, not in use"
        }

        ListItem {
            interactive: false
            icon: "audio-input-microphone-symbolic"
            text: "Microphone"
            active: Privacy.micActive && FrameworkTool.micSwitchOn
            subtext: FrameworkTool.available && !FrameworkTool.micSwitchOn ? "Off (privacy switch)"
                : Privacy.micActive ? "In use by " + Privacy.micApps.join(", ")
                : "On, not in use"
        }
    }

    // --- hardware (framework_tool) ---
    ColumnLayout {
        Layout.fillWidth: true
        visible: root.tab === "Hardware"
        spacing: 4

        InfoRow {
            label: "Expansion bay"
            value: FrameworkTool.bayModule
                + (FrameworkTool.expansionBay["No fault"] === "false" ? " (fault)" : "")
                + (FrameworkTool.expansionBay["Door closed"] === "false" ? " (door open)" : "")
        }
        InfoRow {
            label: "Input modules"
            value: FrameworkTool.inputDeck.filter(m => m !== "Disconnected").join(", ")
        }
        InfoRow { label: "Charge limit (EC)"; value: FrameworkTool.chargeLimit > 0 ? FrameworkTool.chargeLimit + "%" : "" }

        Separator { Layout.topMargin: 4; Layout.bottomMargin: 4 }

        Repeater {
            model: FrameworkTool.firmware

            InfoRow {
                required property var modelData
                label: modelData.name
                value: modelData.version
                valueColor: Theme.subtext0
            }
        }
    }

    // thin usage bar
    component Meter: Rectangle {
        property real value: 0

        Layout.fillWidth: true
        Layout.bottomMargin: 4
        implicitHeight: 4
        radius: 2
        color: Theme.surface0

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, parent.value))
            height: parent.height
            radius: 2
            color: Theme.accent
        }
    }
}
