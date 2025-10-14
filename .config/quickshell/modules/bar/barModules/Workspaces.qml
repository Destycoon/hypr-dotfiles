import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.utils

Rectangle {
    id: workspaces
    color: Colors.lightbg
    implicitWidth: 30
    implicitHeight: 130
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
                color: modelData.active ? Colors.accent : modelData.urgent ? Colors.accentRed : Colors.text
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
