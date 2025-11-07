import QtQuick
import qs.utils
import qs.services.matugen

Item {
    id: container
    implicitWidth: 28
    implicitHeight: 28

    StyledText {
        anchors.centerIn: parent
        font.pixelSize: 16
        color: Matugen.colors.getcolors(Matugen.colors.on_surface)
        text: Matugen.darkmode ? "󰽢" : "󰖨"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Matugen.darkmode = !Matugen.darkmode;
        }
    }
}
