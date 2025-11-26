import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import qs.services.matugen
import qs.utils
import qs.config

PopupWindow {
    id: powerWindow
    color: "transparent"
    property bool active
    visible: active

    implicitWidth: contentRect.width
    implicitHeight: contentRect.height

    anchor {
        rect.x: screen.width
        rect.y: (screen.height / 2) - powerWindow.height / 2
        gravity: Edges.Bottom | Edges.Left
    }

    Process {
        id: shutdownCmd
        command: ["shutdown", "now"]
    }
    Process {
        id: rebootCmd
        command: ["reboot"]
    }
    Process {
        id: lockCmd
        command: ["hyprlock"]
    }

    IpcHandler {
        target: "powerWindow"
        function toggle() {
            ShellContext.togglePower();
        }
    }

    StyledRect {
        id: contentRect
        color: Matugen.colors.getcolors(Matugen.colors.background)
        radius: 18

        width: buttonRow.width + 20
        height: buttonRow.height + 20

        Column {
            id: buttonRow
            anchors.centerIn: parent
            spacing: 10

            Button {
                width: 50
                height: 50
                background: StyledRect {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_power
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    ShellContext.powerOpen = false;
                    shutdownCmd.running = true;
                }
            }

            Button {
                width: 50
                height: 50
                background: StyledRect {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_rotate_cw
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    ShellContext.powerOpen = false;
                    rebootCmd.running = true;
                }
            }

            Button {
                width: 50
                height: 50
                background: StyledRect {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 8
                    StyledText {
                        color: Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 22
                        text: Lucide.icon_lock
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    ShellContext.powerOpen = false;
                    lockCmd.running = true;
                }
            }
        }
    }
}
