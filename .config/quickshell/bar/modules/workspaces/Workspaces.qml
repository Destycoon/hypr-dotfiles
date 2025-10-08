import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: workspaces
    color: "transparent"
    implicitWidth: 40

    ColumnLayout {
        id: workspaceCol
        spacing: 6
        Layout.alignment: Qt.AlignHCenter

        Component.onCompleted: {
            Hyprland.refreshWorkspaces()
        }

        Repeater {
            model: Hyprland.workspaces
            delegate: Rectangle {
                width: 38
                height: 38
                radius: 30
                Layout.alignment: Qt.AlignHCenter   
                color: modelData.active ? "#4cafef"
                      : modelData.urgent ? "#ff6b6b"
                      : "#333"

                Text {
                    anchors.centerIn: parent
                    text: (modelData.name && modelData.name.length)
                        ? modelData.name
                        : String(modelData.id)
                    font.pixelSize: 16
                    color: modelData.active ? "#111111" : "white"
                }

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

