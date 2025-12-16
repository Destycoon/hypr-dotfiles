import QtQuick
import QtQuick.Layouts

import qs.services.matugen
import qs.utils

Item {
    id: root
    anchors.fill: parent

    RowLayout {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 32
        spacing: 12
    
    // Bouton Éteindre
    StyledRect {
        width: 56
        height: 56
        radius: 28
        color: Matugen.colors.getcolors(Matugen.colors.error)
        opacity: 0.9
        
        StyledText {
            anchors.centerIn: parent
            text: Lucide.icon_power_off
            font.pixelSize: 24
            color: Matugen.colors.getcolors(Matugen.colors.on_error)
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.run("systemctl poweroff")
        }
    }
    
    // Bouton Redémarrer
    StyledRect {
        width: 56
        height: 56
        radius: 28
        color: Matugen.colors.getcolors(Matugen.colors.tertiary)
        opacity: 0.9
        
        StyledText {
            anchors.centerIn: parent
            text: Lucide.icon_rotate_cw
            font.pixelSize: 24
            color: Matugen.colors.getcolors(Matugen.colors.on_tertiary)
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.run("systemctl reboot")
        }
    }
    
    // Bouton Quitter la session
    StyledRect {
        width: 56
        height: 56
        radius: 28
        color: Matugen.colors.getcolors(Matugen.colors.primary)
        opacity: 0.9
        
        StyledText {
            anchors.centerIn: parent
            text: Lucide.icon_log_out
            font.pixelSize: 24
            color: Matugen.colors.getcolors(Matugen.colors.on_primary)
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.run("hyprctl dispatch exit")
        }
    }
    }
}
