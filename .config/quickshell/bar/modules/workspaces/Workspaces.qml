import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: workspaces
    color: "#2a2b26"
    implicitWidth: 30
    implicitHeight: 130
    radius : 30

    ColumnLayout {
        id: workspaceCol
        spacing: 5
	anchors {
		fill : parent
		topMargin : 5
		bottomMargin : 5
	}

        Component.onCompleted: {
            Hyprland.refreshWorkspaces()
        }

        Repeater {
            model: Hyprland.workspaces
	delegate: Rectangle {
        	id: workspace
        	implicitWidth:  18
        	implicitHeight: modelData.active ? 30 : 18
		radius: 30
                Layout.alignment: Qt.AlignHCenter   
                color: modelData.active ? "#7aa2f7"
                      : modelData.urgent ? "#f7768e"
                      : "#FFF"
                  MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (modelData && typeof modelData.activate === "function") {
                            modelData.activate()
                        } else {
                            Hyprland.dispatch(`workspace ${modelData.id}`)
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event && event.name && event.name.indexOf("workspace") !== -1) {
                Hyprland.refreshWorkspaces()
            }
        }
    }
}
