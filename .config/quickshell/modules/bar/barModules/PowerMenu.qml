import qs.utils

import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services.matugen

PanelWindow {
    id: powerWindow
    implicitWidth: 490
    implicitHeight: 170
    color: "transparent"

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
            powerWindow.visible = !powerWindow.visible;
        }
    }
    Rectangle {
        anchors.fill: parent
        color: Matugen.colors.getcolors(Matugen.colors.background)
        radius: 24

        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Button {
                width: 150
                height: 150
                background: Rectangle {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)
                    radius: 14

                    StyledText {

			    color : Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 100
                        text: ""
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    powerWindow.visible = false;
                    shutdownCmd.running = true;
                }
            }

            Button {
                width: 150
                height: 150
                background: Rectangle {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)

                    radius: 14
		    StyledText {

			    color : Matugen.colors.getcolors(Matugen.colors.on_primary)
                        font.pixelSize: 100
                        text: ""
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    powerWindow.visible = false;
                    rebootCmd.running = true;
                }
            }

            Button {
                width: 150
                height: 150
                background: Rectangle {
                    color: Matugen.colors.getcolors(Matugen.colors.primary)

                    radius: 14
		    StyledText {
			    color : Matugen.colors.getcolors(Matugen.colors.on_primary)

                        font.pixelSize: 100
                        text: ""
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    powerWindow.visible = false;
                    lockCmd.running = true;
                }
            }
        }
    }
}
