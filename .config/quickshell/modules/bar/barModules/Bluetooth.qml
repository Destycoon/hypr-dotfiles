import Quickshell
import QtQuick
import Quickshell.Bluetooth
import qs.utils
import qs.services.matugen

Item {
    id: container
    implicitWidth: 28
    implicitHeight: 28

    property BluetoothAdapter adapter: Bluetooth.defaultAdapter

    StyledText {
        id: icon
        anchors.centerIn: parent
        color: adapter?.enabled ? Matugen.colors.getcolors(Matugen.colors.on_surface) : Matugen.colors.getcolors(Matugen.colors.on_secondary_container)
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
