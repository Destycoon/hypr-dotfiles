import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
    id: powerRoot
    width: 40
    height: 40
    color: "transparent"

    Text {
        text: ""
        anchors.centerIn: parent
        font.pixelSize: 20
        color: "white"

        
	}
Process {
    id: menu
    running: false
    command: ["qs", "-p", "/home/destycoon/hypr-dotfiles/.config/quickshell/bar/modules/power_menu/PowerMenu.qml"]
}

MouseArea {
            anchors.fill: parent
            onClicked: {
        menu.running = !menu.running
        }
}
}
