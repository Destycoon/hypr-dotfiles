import QtQuick
import qs.utils.anim

Rectangle {
    id: root
    color: "transparent"

    Behavior on color {
        CAnim {}
    }
}
