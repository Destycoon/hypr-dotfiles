import qs.utils

import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

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

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    IpcHandler {
        target: "powerWindow"

        function toggle() {
            powerWindow.visible = !powerWindow.visible;
        }
    }
    Rectangle {
        anchors.fill: parent
        color: Colors.bg
        radius: 24

        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Button {
                width: 150
                height: 150
                background: Rectangle {
                    color: Colors.lightbg
                    radius: 14

                    StyledText {

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
                    color: Colors.lightbg
                    radius: 14
                    StyledText {
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
                    color: Colors.lightbg
                    radius: 14
                    StyledText {
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
