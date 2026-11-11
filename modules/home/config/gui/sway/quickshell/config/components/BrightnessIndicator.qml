import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"
import "../data"
import "ui"

// Screen brightness: scroll on the icon to change the laptop panel, click for one slider per
// screen. External monitors are listed but greyed out until DDC/CI (ddcutil) is set up.
BarModule {
    id: root

    // laptop panel first
    readonly property var screens: Quickshell.screens.slice().sort((a, b) => isInternal(b) - isInternal(a))

    function isInternal(screen): bool { return screen.name.startsWith("eDP"); }

    kind: "brightness"
    visible: Brightness.available
    icon: Brightness.icon
    popupWidth: 280

    onScrolled: (delta) => Brightness.set(Brightness.value + (delta > 0 ? 0.05 : -0.05))

    PanelHeader {
        icon: Brightness.icon
        title: "Brightness"
    }

    Separator { }

    Repeater {
        model: root.screens

        ColumnLayout {
            id: display
            required property var modelData
            required property int index
            readonly property bool internal: root.isInternal(modelData)
            // the model is often unknown -> fall back to the output name (then shown only once)
            readonly property bool knownModel: modelData.model !== "" && modelData.model.toLowerCase() !== "unknown"

            Layout.fillWidth: true
            spacing: 6

            Separator { visible: display.index > 0; Layout.bottomMargin: 4 }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                opacity: display.internal ? 1 : 0.4

                Icon {
                    icon: display.internal ? Icons.laptop : Icons.monitor
                    size: 16
                }

                StyledText {
                    Layout.fillWidth: true
                    text: display.internal ? "Laptop display" : display.knownModel ? display.modelData.model : display.modelData.name
                    font.pixelSize: Theme.smallFontSize + 1
                }

                StyledText {
                    visible: display.internal || display.knownModel
                    text: display.internal ? Brightness.text : display.modelData.name
                    color: Theme.subtext0
                    font.pixelSize: Theme.smallFontSize
                }
            }

            Slider {
                Layout.fillWidth: true
                opacity: display.internal ? 1 : 0.4
                enabled: display.internal
                value: display.internal ? Brightness.value : 0
                onMoved: (value) => Brightness.set(value)
            }

            StyledText {
                visible: !display.internal
                opacity: 0.4
                text: "Needs DDC/CI (ddcutil), not set up yet"
                color: Theme.subtext0
                font.pixelSize: Theme.smallFontSize - 1
            }
        }
    }
}
