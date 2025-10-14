import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.utils

Rectangle {
    id: container
    height: 90
    width: 30
    radius: 30
    color: Colors.lightbg

    ColumnLayout {
        spacing: 5

        PowerProfile {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
        }

        Bluetooth {
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
