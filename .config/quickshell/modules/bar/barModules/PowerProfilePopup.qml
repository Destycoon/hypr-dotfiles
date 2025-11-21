import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import qs.services.matugen
import qs.utils
import Quickshell.Services.UPower

PopupWindow {
    id: powerWindow
    color: "transparent"

    property bool active
    visible: active

    implicitWidth: contentRect.implicitWidth
    implicitHeight: contentRect.implicitHeight

    anchor {
        rect.x: powerWindow.width + 55
        rect.y: screen.height - powerWindow.implicitHeight - 220
        gravity: Edges.Bottom | Edges.Left
    }

    readonly property color bg: Matugen.colors.getcolors(Matugen.colors.background)
    readonly property color btnBg: Matugen.colors.getcolors(Matugen.colors.primary)
    readonly property color btnFg: Matugen.colors.getcolors(Matugen.colors.on_primary)

    Rectangle {
        id: contentRect
        radius: 18
        color: bg
        implicitHeight: col.height + 20
        implicitWidth: col.width + 20

        Column {
            id: col
            spacing: 14
            anchors.centerIn: parent

            StyledText {
                text: UPower.displayDevice.isPresent ? "Battery :" : "No UPower device"
                font.pixelSize: 14
            }
            StyledText {
                font.pixelSize: 14
                text: {
                    if (PowerProfiles.profile == PowerProfile.Performance) {
                        return "Power profile : Performance";
                    } else if (PowerProfiles.profile == PowerProfile.PowerSaver) {
                        return "Power profile : Power-Saver";
                    } else if (PowerProfiles.profile == PowerProfile.Balanced) {
                        return "Power profile : Balanced";
                    }
                }
            }

            Row {
                id: row
                spacing: 10

                Button {
                    width: 50
                    height: 50
                    background: Rectangle {
                        radius: 10
                        color: btnBg
                        StyledText {
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            color: btnFg
                            text: Lucide.icon_leaf
                        }
                    }
                    onClicked: PowerProfiles.profile = PowerProfile.PowerSaver
                }

                Button {
                    width: 50
                    height: 50
                    background: Rectangle {
                        radius: 10
                        color: btnBg
                        StyledText {
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            color: btnFg
                            text: ""
                        }
                    }
                    onClicked: PowerProfiles.profile = PowerProfile.Balanced
                }

                Button {
                    width: 50
                    height: 50
                    background: Rectangle {
                        radius: 10
                        color: btnBg
                        StyledText {
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            color: btnFg
                            text: Lucide.icon_zap
                        }
                    }
                    onClicked: PowerProfiles.profile = PowerProfile.Performance
                }
            }
        }
    }
}
