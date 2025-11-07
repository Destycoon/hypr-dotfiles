import Quickshell
import QtQuick
import qs.utils
import qs.services.matugen

Rectangle {
    implicitWidth: 600
    implicitHeight: 500
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    radius: 18
}
