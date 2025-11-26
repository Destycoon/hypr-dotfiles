import QtQuick
import qs.utils

StyledRect {
    id: powerRoot
    width: 40
    height: 40
    color: "transparent"

    StyledText {
        anchors.centerIn: parent
        font.pixelSize: 20
        text: ""
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            ShellContext.togglePower();
        }
    }
}
