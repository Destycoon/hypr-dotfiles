import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.utils
import qs.services.matugen

Rectangle {
    id: workspaces
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    implicitWidth: 30
    implicitHeight: 140
    radius: 30
    ColumnLayout {
        id: workspaceCol
        spacing: 5
        anchors {
            fill: parent
            topMargin: 5
            bottomMargin: 5
        }

        Component.onCompleted: {
            Hyprland.refreshWorkspaces();
        }

        Repeater {
            model: Hyprland.workspaces
            delegate: Rectangle {
                id: workspace
                implicitWidth: 18
                implicitHeight: modelData.active ? 30 : 18
                radius: 30
                Layout.alignment: Qt.AlignHCenter
                color: modelData.active ? Matugen.colors.getcolors(Matugen.colors.primary) : modelData.urgent ? Matugen.color.getcolors(Matugen.colors.error) : Matugen.colors.getcolors(Matugen.colors.secondary)
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (modelData && typeof modelData.activate === "function") {
                            modelData.activate();
                        } else {
                            Hyprland.dispatch(`workspace ${modelData.id}`);
                        }
                    }
                }
                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 150
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event && event.name && event.name.indexOf("workspace") !== -1) {
                Hyprland.refreshWorkspaces();
            }
        }
    }
}
