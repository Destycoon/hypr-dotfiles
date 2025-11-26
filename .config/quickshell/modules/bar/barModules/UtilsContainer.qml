import QtQuick
import qs.services.matugen
import qs.utils

StyledRect {
    id: container
    height: 90
    width: 30
    radius: 30
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)

    Column {
        anchors.fill: parent
        spacing: 3
        anchors.topMargin: 3
        anchors.bottomMargin: 3
        Bluetooth {}
        PowerProfile {}
    }
}
