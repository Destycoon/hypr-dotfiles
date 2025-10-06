import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Rectangle {
    id: workspaces
    color: "transparent"
    implicitWidth: 40
    anchors.centerIn : parent

    ColumnLayout {
        id: workspaceCol
        anchors.fill: parent
        spacing: 6

        Component.onCompleted: {
            Hyprland.refreshWorkspaces()
        }

        Repeater {
            model: Hyprland.workspaces   // <-- l'objet modèle fourni par Quickshell.Hyprland
            delegate: Rectangle {
                width: 32
                height: 32
                radius: 6

                // modelData est l'objet HyprlandWorkspace (ObjectModel expose "modelData")
                color: modelData.active ? "#4cafef" : (modelData.urgent ? "#ff6b6b" : "#333")

                Text {
                    anchors.centerIn: parent
                    text: (modelData.name && modelData.name.length) ? modelData.name : String(modelData.id)
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // préférence : appeler la fonction activate() fournie par l'objet workspace
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

    // Réagir aux événements Hyprland et rafraîchir si nécessaire
Connections {
    target: Hyprland
    function onRawEvent(event) {
        if (event && event.name && event.name.indexOf("workspace") !== -1) {
            Hyprland.refreshWorkspaces()
        }
    }
}
} 


