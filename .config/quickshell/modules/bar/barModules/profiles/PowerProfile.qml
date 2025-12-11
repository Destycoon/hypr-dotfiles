import QtQuick
import Quickshell.Services.UPower
import qs.utils
import qs.config

StyledRect {
    id: powerProfileIcon

    implicitWidth: 28
    implicitHeight: 28
    color: "transparent"

    StyledText {
        anchors.centerIn: parent

        font.pixelSize: 18
        text: {
            if (PowerProfiles.profile == PowerProfile.Performance) {
                return Lucide.icon_zap;
            } else if (PowerProfiles.profile == PowerProfile.PowerSaver) {
                return Lucide.icon_leaf;
            } else if (PowerProfiles.profile == PowerProfile.Balanced) {
                return "";
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            ShellContext.toggleProfile();
        }
    }
}
