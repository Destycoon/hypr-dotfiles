import Quickshell
import QtQuick
import Quickshell.Services.UPower
import qs.utils

Rectangle {
    id: powerProfileIcon

    implicitWidth: 28
    implicitHeight: 28
    color: "transparent"
    Text {
        id: profileText
        anchors.centerIn: parent
        text: {
            switch (PowerProfiles.profile) {
            case PowerProfiles.Performance:
                return "󱐋";
            case PowerProfiles.Balanced:
                return "";
            case PowerProfiles.PowerSaver:
                return "";
            default:
                return "";
            }
        }
        font.pixelSize: 16
        color: Colors.text
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            switch (PowerProfiles.profile) {
            case PowerProfiles.Performance:
                PowerProfiles.profile = PowerProfiles.Balanced;
                break;
            case PowerProfiles.Balanced:
                PowerProfiles.profile = PowerProfiles.PowerSaver;
                break;
            case PowerProfiles.PowerSaver:
                PowerProfiles.profile = PowerProfiles.Performance;
                break;
            }
        }
    }
}
