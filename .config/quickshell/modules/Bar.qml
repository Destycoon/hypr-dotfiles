import Quickshell
import QtQuick
import QtQuick.Layouts
import "clock"
import "workspaces"

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                left: true
                bottom: true
            }

            margins {
                top: 5
                bottom: 5
                left: 5
            }
            implicitWidth: 40

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: "#88222222"
            }

            ColumnLayout {
                id: content
                anchors.fill: parent
                spacing: 10

                Item {
                    Layout.fillHeight: true
                }

                Workspaces {
			Layout.alignment : Qt.AlingHCenter
                }

                Item {
                    Layout.fillHeight: true
                }

                Clock {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                }
            }
        }
    }
}


