import QtQuick
import Quickshell.Io
import qs.utils

Rectangle {
    id: powerRoot
    width: 40
    height: 40
    color: "transparent"

    Text {
        text: ""
        anchors.centerIn: parent
        font.pixelSize: 20
        color: Colors.text
    }
    Process {
        id: menu
        running: false
        command: ["bash", "~/.config/scripts/power_meu.sh"]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            menu.running = !menu.running;
        }
    }
}
