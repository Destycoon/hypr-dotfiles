import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland 

PanelWindow {
    id: powerWindow
    implicitWidth: 490
    implicitHeight: 170 
    visible: false
    color: "transparent"
    
    Process { id: shutdownCmd; command: ["shutdown", "now"] }
    Process { id: rebootCmd; command: ["reboot"] }
    Process { id: lockCmd; command: ["hyprlock"] }

    MouseArea {
        anchors.fill: parent
        onClicked: powerWindow.visible = false
        z: -2
    }

    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        radius: 24

        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Button {
                width: 150
                height: 150
                background: Rectangle {
                    color: "#4cafef"
                    border.color: "#4cafef"
                    border.width: 4
                    radius: 14

                    Text {
                        text: ""
                        color: "#1a1b26"
                        font.pixelSize: 100
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    powerWindow.visible = false
                    shutdownCmd.running = true
                }
            }

            Button {
                width: 150
                height: 150
                background: Rectangle {
                    color: "#4cafef"
                    border.color: "#4cafef"
                    border.width: 4
                    radius: 14

                    Text {
                        text: ""
                        color: "#1a1b26"
                        font.pixelSize: 100
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    powerWindow.visible = false
                    rebootCmd.running = true
                }
            }

            Button {
                width: 150
                height: 150
                background: Rectangle {
                    color: "#4cafef"
                    border.color: "#4cafef"
                    border.width: 4
                    radius: 14

                    Text {
                        text: ""
                        color: "#1a1b26"
                        font.pixelSize: 100
                        anchors.centerIn: parent
                    }
                }
                onClicked: {
                    powerWindow.visible = false
                    lockCmd.running = true
                }
            }
        }
    }
}

