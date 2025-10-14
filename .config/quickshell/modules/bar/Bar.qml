import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.bar.barModules
import qs.utils

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
                top: 8
                bottom: 8
                left: 8
            }

            implicitWidth: 50

            Rectangle {
                id: background
                anchors.fill: parent
                radius: 12
                color: Colors.bg
            }

            ColumnLayout {
                id: content
                anchors {
                    fill: parent
                    margins: 6
                }
                spacing: 20

                Battery {
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillHeight: true
                }

                Workspaces {
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillHeight: true
                }

                UtilsContainer {
                    Layout.alignment: Qt.AlignHCenter
                }
                Clock {
                    Layout.alignment: Qt.AlignHCenter
                }

                Power {
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
