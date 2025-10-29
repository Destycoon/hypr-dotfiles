import Quickshell
import QtQuick
import qs.utils
import QtQuick.Layouts
import "modules"
import Quickshell.Io
import QtQuick.Controls

PanelWindow {
    id: dashboard

    color: "transparent"

    implicitWidth: child.implicitWidth + 20
    implicitHeight: child.implicitHeight + 80

    visible: false
    IpcHandler {
        target: "dashboard"

        function toggle(): void {
            dashboard.visible = !dashboard.visible;
        }
    }
    Rectangle {
        width: parent.width
        height: parent.height
        radius: 28
        color: Colors.bg

        ColumnLayout {
            spacing: 10
            anchors.fill: parent
            anchors.margins: 10

            Rectangle {
                id: buttonContainer
                implicitWidth: child.implicitWidth
                Layout.alignment: Qt.AlignHCenter
                radius: 18
                color: Colors.lightbg
                implicitHeight: 50
                RowLayout {
                    implicitWidth: parent.implicitWidth
                    implicitHeight: parent.implicitWidth
                    spacing: 3
                    uniformCellSizes: true
                    anchors.centerIn: parent
                    Button {
                        implicitWidth: (buttonContainer.implicitWidth / 4) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10
                        background: Rectangle {

                            color: Colors.bg
                            radius: 13

                            StyledText {
                                text: "󰕮"
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.centerIn: parent
                            }
                        }
                    }

                    Button {
                        implicitWidth: (buttonContainer.implicitWidth / 4) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10

                        background: Rectangle {

                            color: Colors.bg
                            radius: 13

                            StyledText {
                                text: "󰦚"
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.centerIn: parent
                            }
                        }
                    }
                    Button {
                        implicitWidth: (buttonContainer.implicitWidth / 4) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10

                        background: Rectangle {

                            color: Colors.bg
                            radius: 13

                            StyledText {
                                text: ""
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.centerIn: parent
                            }
                        }
                    }
                    Button {
                        implicitWidth: (buttonContainer.implicitWidth / 4) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10

                        background: Rectangle {

                            color: Colors.bg
                            radius: 13

                            StyledText {
                                text: "󰸉"
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
            WallpaperSelector {
                id: child
            }
        }
    }
}
