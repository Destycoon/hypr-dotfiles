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

    implicitWidth: contentRect.width
    implicitHeight: contentRect.height

    anchor {
        rect.x: powerWindow.width + 55
        rect.y: powerWindow.height / 2
        gravity: Edges.Bottom | Edges.Left
    }

    Rectangle {
        id: contentRect
        color: Matugen.colors.getcolors(Matugen.colors.background)
        radius: 18

        width: buttonRow.width + 20
        height: buttonRow.height + 20

        Row {
            id: buttonRow
            anchors.centerIn: parent
            spacing: 10

            Button {
                width: 50
                height: 50
                background: Rectangle {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_leaf
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    PowerProfiles.profile = PowerProfile.PowerSaver;
                }
            }

            Button {
                width: 50
                height: 50
                background: Rectangle {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: ""
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    PowerProfiles.profile = PowerProfile.Balanced;
                }
            }

            Button {
                width: 50
                height: 50
                background: Rectangle {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_zap
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    PowerProfiles.profile = PowerProfile.PowerSaver;
                }
            }
        }
    }
}
