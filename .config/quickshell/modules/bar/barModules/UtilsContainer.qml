import QtQuick
import qs.services.matugen
import qs.utils
import qs.modules.bar.barModules.profiles

StyledRect {
    id: container
    implicitHeight: col.height + 6
    implicitWidth: col.width + 3
    radius: 30
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)

    Column {
        id: col
        anchors.centerIn: parent
        spacing: 3
        Bluetooth {}
        PowerProfile {}
    }
}
