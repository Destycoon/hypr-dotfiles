import Quickshell
import QtQuick
import qs.utils

Rectangle {
    id: powerRoot
    width: 40
    height: 40
    color: "transparent"

    StyledText {
        anchors.centerIn: parent
        font.pixelSize: 20
        text: ""
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            loader.item.visible = !loader.item.visible;
        }
    }
    Loader {
        id: loader
        onLoaded: loader.item.visible = !loader.item.visible
    }
    Component.onCompleted: {
        loader.setSource("PowerMenu.qml");
    }
}
