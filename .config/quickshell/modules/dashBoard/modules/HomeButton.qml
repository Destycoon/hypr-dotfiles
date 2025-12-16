import Quickshell
import QtQuick
import QtQuick.Controls

import qs.utils
import qs.services.matugen

StyledRect {
    id: root
    implicitWidth: 40
    implicitHeight: 40
    color: Matugen.darkmode ? Matugen.colors.getcolors(Matugen.colors.surface_bright) : Matugen.colors.getcolors(Matugen.colors.surface_dim)
    radius: 18
}
