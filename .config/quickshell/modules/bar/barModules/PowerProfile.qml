import QtQuick
import Quickshell.Services.UPower
import qs.utils
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: powerProfileIcon

    radius: 18
    implicitWidth: 170
    implicitHeight: 60
    color: Colors.bg

    RowLayout {
        Button {
            id: performance
            text: "󱐋"
            onClicked: {
                PowerProfiles.profile = PowerProfiles.Performance;
            }
            background: Rectangle {
                radius: 13
                implicitWidth: 50
                implicitHeight: 50
                color: Colors.lightbg
            }
        }
        Button {
            id: balance
            text: ""
            onClicked: {
                PowerProfiles.profile = PowerProfiles.Balanced;
            }
            background: Rectangle {
                radius: 13
                implicitWidth: 50
                implicitHeight: 50
                color: Colors.lightbg
            }
        }
        Button {
            id: low
            text: ""
            onClicked: {
                PowerProfiles.profile = PowerProfiles.PowerSaver;
            }
            background: Rectangle {
                radius: 13
                implicitWidth: 50
                implicitHeight: 50
                color: Colors.lightbg
            }
        }
    }
}
