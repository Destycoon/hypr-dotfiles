pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.utils
import qs.services.matugen
import qs.config

Item {
    id: root

    implicitWidth: 40
    implicitHeight: 40
    StyledRect {
        anchors.fill: parent
        color: "transparent"

        StyledText {
            font.pixelSize: 24
            anchors.centerIn: parent
            text: "󰣇"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                ShellContext.toggleLauncher();
            }
        }
    }
}
