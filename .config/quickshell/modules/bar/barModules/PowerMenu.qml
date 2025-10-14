import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.utils

PanelWindow {
    id: powerWindow
    implicitWidth: 490
    implicitHeight: 170
    color: "transparent"
    Component.onCompleted: {
        this.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive;
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

    Rectangle {
        anchors.fill: parent
        color: Colors.lightbg
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
                    border.color: Colors.border
                    border.width: 4
                    radius: 14

                    Text {
                        text: ""
                        color: Colors.text
                        font.pixelSize: 100
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
                    border.color: Colors.border
                    border.width: 4
                    radius: 14

                    Text {
                        text: ""
                        color: Colors.text
                        font.pixelSize: 100
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
                    border.color: Colors.border
                    border.width: 4
                    radius: 14

                    Text {
                        text: ""
                        color: Colors.text
                        font.pixelSize: 100
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
