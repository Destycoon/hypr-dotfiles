import Quickshell
import QtQuick
import qs.utils
import QtQuick.Layouts
import Quickshell.Io
import QtQuick.Controls
import qs.services.matugen

PanelWindow {
    id: dashboard

    color: "transparent"
    property string child: "./modules/Home.qml"
    visible: false
    IpcHandler {
        target: "dashboard"

        function toggle(): void {
            dashboard.visible = !dashboard.visible;
        }
    }
    focusable: true

    Rectangle {

        width: parent.width
        height: parent.height
        radius: 28
        color: Matugen.colors.getcolors(Matugen.colors.background)

        ColumnLayout {
            spacing: 10
            anchors.fill: parent
            anchors.margins: 10

            Rectangle {
                id: buttonContainer
                implicitWidth: implicitWidth
                Layout.alignment: Qt.AlignHCenter
                radius: 18
                color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)

                implicitHeight: 50
                RowLayout {
                    implicitWidth: parent.implicitWidth
                    implicitHeight: parent.implicitWidth
                    spacing: 3
                    anchors.centerIn: parent
                    Button {
                        implicitWidth: (buttonContainer.implicitWidth / 3) - 5
                        implicitHeight: buttonContainer.implicitHeight - 10
                        onClicked: {
                            dashboard.child = "./modules/Home.qml";
                        }
                        background: Rectangle {

                            color: (dashboard.child == "./modules/Home.qml") ? Matugen.colors.getcolors(Matugen.colors.primary) : Matugen.colors.getcolors(Matugen.colors.secondary)
                            radius: 13

                            StyledText {
                                text: "󰕮  Home"
                                color: (dashboard.child == "./modules/Home.qml") ? Matugen.colors.getcolors(Matugen.colors.on_primary) : Matugen.colors.getcolors(Matugen.colors.on_secondary)
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
                            color: (dashboard.child == "./modules/Player.qml") ? Matugen.colors.getcolors(Matugen.colors.primary) : Matugen.colors.getcolors(Matugen.colors.secondary)
                            radius: 13

                            StyledText {
                                color: (dashboard.child == "./modules/Player.qml") ? Matugen.colors.getcolors(Matugen.colors.on_primary) : Matugen.colors.getcolors(Matugen.colors.on_secondary)
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

                            color: (dashboard.child == "./modules/WallpaperSelector.qml") ? Matugen.colors.getcolors(Matugen.colors.primary) : Matugen.colors.getcolors(Matugen.colors.secondary)
                            radius: 13

                            StyledText {
                                color: (dashboard.child == "./modules/WallpaperSelector.qml") ? Matugen.colors.getcolors(Matugen.colors.on_primary) : Matugen.colors.getcolors(Matugen.colors.on_secondary)
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
                onSourceChanged: {
                    opacity: 0;
                }
                focus: true
                onLoaded: {
                    if (!item)
                        return;
                    dashboard.implicitWidth = item.implicitWidth + 20;
                    dashboard.implicitHeight = item.implicitHeight + 80;
                    buttonContainer.implicitWidth = item.implicitWidth;

                    opacity: 1;

                    item.implicitWidthChanged.connect(() => dashboard.implicitWidth = item.implicitWidth + 20);
                    item.implicitHeightChanged.connect(() => dashboard.implicitHeight = item.implicitHeight + 80);

                    item.focus = true;
                    item.forceActiveFocus();
                }
            }
        }
    }
}
