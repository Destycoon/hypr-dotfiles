import QtQuick
import qs.utils
import qs.services

Item {
    width: 40
    height: 70

    StyledText {
        id: root
        anchors.centerIn: parent
        text: Time.format("hh") + "\n" + Time.format("mm")
        font.pixelSize: 20
    }
}
