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
        font.family: "lucide"
        color: Matugen.colors.getcolors(Matugen.colors.on_surface)
        text: Matugen.darkmode ? Lucide.icon_moon_star : Lucide.icon_sun
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Matugen.toggleDark();
        }
    }
}
