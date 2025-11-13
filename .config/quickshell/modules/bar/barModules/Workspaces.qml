import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.services.matugen

Rectangle {
    id: workspaces
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    implicitWidth: 30
    radius: 30

    property int workspaceCount: Hyprland.workspaces && Hyprland.workspaces.values ? Hyprland.workspaces.values.length : 4
    property real minWorkspaces: 4
    property real effectiveCount: Math.max(workspaceCount, minWorkspaces)

    implicitHeight: 10 + (effectiveCount * 24) + ((effectiveCount - 1) * 5)

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

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
                color: modelData.active ? Matugen.colors.getcolors(Matugen.colors.primary) : modelData.urgent ? Matugen.colors.getcolors(Matugen.colors.error) : Matugen.colors.getcolors(Matugen.colors.secondary)

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
