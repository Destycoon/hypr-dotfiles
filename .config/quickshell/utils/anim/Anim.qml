import qs.config
import QtQuick

NumberAnimation {
    duration: GraphicConfig.anim.durations.normal
    easing.type: Easing.BezierSpline
    easing.bezierCurve: GraphicConfig.anim.curves.standard
}
