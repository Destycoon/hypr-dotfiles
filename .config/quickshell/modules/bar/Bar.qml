import Quickshell
import QtQuick
import qs.modules.bar.barModules
import qs.utils
import qs.services.matugen
import qs.config

StyledRect {
    id: background
    anchors.fill: parent
    radius: 12
    color: Matugen.colors.getcolors(Matugen.colors.background)

    Item {
        anchors.fill: parent

        Column {
            id: top
            spacing: 10
            anchors.top: parent.top
            anchors.topMargin: 10

            anchors.horizontalCenter: parent.horizontalCenter
            App {}
            Workspaces {
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            id: bottom
            spacing: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            UtilsContainer {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Clock {
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Battery {
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Power {}
        }
        Column {
            id: center
            spacing: 10
            anchors.centerIn: parent
        }
    }
}
