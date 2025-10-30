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

    property string child: "./modules/Player.qml"
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
                implicitWidth: implicitWidth
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
                        implicitWidth: (buttonContainer.implicitWidth / 3) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10
                        background: Rectangle {

                            color: Colors.bg
                            radius: 13

                            StyledText {
                                text: "󰕮  Home"
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.centerIn: parent
                            }
                        }
                    }

                    Button {
                        implicitWidth: (buttonContainer.implicitWidth / 3) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10

                        onClicked: {
                            dashboard.child = "./modules/Player.qml";
                        }

                        background: Rectangle {

                            color: Colors.bg
                            radius: 13

                            StyledText {
                                text: "󰦚  Player"
                                anchors.centerIn: parent
                            }
                        }
                    }

                    Button {
                        implicitWidth: (buttonContainer.implicitWidth / 3) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10
                        onClicked: {
                            dashboard.child = "./modules/WallpaperSelector.qml";
                        }
                        background: Rectangle {

                            color: Colors.bg
                            radius: 13

                            StyledText {
                                text: "󰸉  Wallpaper"
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
            Loader {
                id: loader
                source: dashboard.child

                onLoaded: {
                    if (!item)
                        return;
                    dashboard.implicitWidth = item.implicitWidth + 20;
                    dashboard.implicitHeight = item.implicitHeight + 80;
                    buttonContainer.implicitWidth = item.implicitWidth;

                    item.implicitWidthChanged.connect(() => dashboard.implicitWidth = item.implicitWidth + 20);
                    item.implicitHeightChanged.connect(() => dashboard.implicitHeight = item.implicitHeight + 80);
                }
            }
        }
    }
}
