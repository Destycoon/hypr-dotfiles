import Quickshell
import QtQuick
import qs.modules.bar.barModules
import qs.utils
import qs.services.matugen

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

            PowerProfilePopup {
                active: ShellContext.showPProfile
                anchor.window: bar
            }
            Rectangle {
                id: background
                anchors.fill: parent
                radius: 12
                color: Matugen.colors.getcolors(Matugen.colors.background)

                Item {
                    anchors.fill: parent

                    Column {
                        id: top
                        spacing: 10
                        anchors.top: parent.top
                        anchors.topMargin: 10

                        anchors.horizontalCenter: parent.horizontalCenter
                        App {}
                        Workspaces {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        id: bottom
                        spacing: 5
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        UtilsContainer {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Clock {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Battery {}
                        Power {}
                        PowerMenu {
                            active: ShellContext.powerOpen
                            anchor.window: bar
                        }
                    }
                    Column {
                        id: center
                        spacing: 10
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
