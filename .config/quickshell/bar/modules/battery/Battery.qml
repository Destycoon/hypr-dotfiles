import Quickshell
import QtQuick
import Quickshell.Services.UPower

Item {
    id: container
    width: 40
    height: 40

    Rectangle {
        id: bat
        width: container.width * 0.9
        height: container.height * 0.7
        radius: 8
        color: "#333333"
        anchors.centerIn: parent

        property real percent: UPower.displayDevice.percentage * 100
    }

    Item {
        anchors.centerIn: parent
        Row {
            spacing: 3
            anchors.centerIn: parent

            Text {
                text: bat.percent.toFixed(0)
                color: "white"
                font.bold: true
                font.pixelSize: 14
            }

            Text {
                text: "󰂄"
                visible: UPower.displayDevice.state == UPowerDeviceState.Charging
                color: "lime"
                font.pixelSize: 14
            }
        }
    }
}

