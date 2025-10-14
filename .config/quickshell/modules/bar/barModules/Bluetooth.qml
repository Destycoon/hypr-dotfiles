import Quickshell
import QtQuick
import Quickshell.Bluetooth
import qs.utils

Item {
    id: container
    implicitWidth: 28
    implicitHeight: 28

    property BluetoothAdapter adapter: Bluetooth.defaultAdapter

    Text {
        id: icon
        anchors.centerIn: parent
        text: adapter.enabled ? "󰂯" : "󰂲"
        color: adapter.enabled ? Colors.text : Color.textmuted
        font.pixelSize: 18
    }
}
