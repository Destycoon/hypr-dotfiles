import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
    id: powerRoot
    width: 40
    height: 40
    color: "transparent"

    Loader {
        id: powerPopupLoader
        source: "PowerMenu.qml"
    }

    Text {
        text: ""
        anchors.centerIn: parent
        font.pixelSize: 20
        color: "white"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (powerPopupLoader.item) {
                    powerPopupLoader.item.visible = !powerPopupLoader.item.visible
                }
            }
        }
    }
}

