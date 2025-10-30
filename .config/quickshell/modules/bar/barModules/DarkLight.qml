import QtQuick
import qs.utils

Item {
    id: container
    implicitWidth: 28
    implicitHeight: 28

    property bool dark

    StyledText {
        anchors.centerIn: parent
        font.pixelSize: 16
        color: Colors.text
        text: dark ? "󰽢" : "󰖨"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            dark = !dark;
        }
    }
}
