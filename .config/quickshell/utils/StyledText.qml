pragma ComponentBehavior: Bound

import QtQuick
import qs.services.matugen
import qs.utils.anim
import qs.config

Text {
    id: text

    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration: GraphicConfig.anim.durations.normal

    color: Matugen.colors.getcolors(Matugen.colors.on_background)

    font.family: "Hubot Sans"
    font.pixelSize: 18

    renderType: Text.NativeRendering
    textFormat: Text.PlainText

    Behavior on color {
        CAnim {}
    }
}
