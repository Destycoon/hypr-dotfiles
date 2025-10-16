import Quickshell
import QtQuick
import Quickshell.Bluetooth
import qs.utils

Item {
    id: container
    implicitWidth: 28
    implicitHeight: 28

    property BluetoothAdapter adapter: Bluetooth.defaultAdapter

    StyledText {
        id: icon
        anchors.centerIn: parent
        color: adapter?.enabled ? Colors.text : Colors.textMuted
        text: adapter?.enabled ? "󰂯" : "󰂲"
        font.pixelSize: 18
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            adapter.enabled = !adapter.enabled;
        }
    }
}
