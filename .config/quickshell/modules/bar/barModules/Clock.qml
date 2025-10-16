import QtQuick
import qs.utils
import qs.modules.dashBoard
import qs.services

Item {
    width: 40
    height: 40

    StyledText {
        id: root
        anchors.centerIn: parent
        text: Time.format("hh") + "\n" + Time.format("mm")
        font.pixelSize: 20
    }
    DashBoard {
        id: dash
        visible: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            dash.visible = !dash.visible;
        }
    }
}
