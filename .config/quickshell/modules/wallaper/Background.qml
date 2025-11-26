import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.utils
import qs.services.matugen

PanelWindow {

    color: "transparent"

    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }
    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore
    Rectangle {
        anchors.centerIn: parent
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: Matugen.colors.getcolors(Matugen.colors.background)

        Rectangle {
            id: mask
            implicitWidth: parent.width - 20
            implicitHeight: parent.height - 20
            anchors.centerIn: parent
            radius: 30
            border.width: 40

            layer.enabled: true
        }

        Image {
            id: cover
            anchors.fill: mask
            source: "file:///home/destycoon/.config/wallpaper/pixelTree.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            layer.enabled: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: mask
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        }
    }
}
