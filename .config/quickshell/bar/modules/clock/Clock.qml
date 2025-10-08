import Quickshell
import QtQuick
import Quickshell.Io

Item {
    width: 40
    height: 40

    Text {
        id: root
        anchors.centerIn: parent
        text: Qt.formatTime(new Date(), "hh") + "\n" + Qt.formatTime(new Date(), "mm")
        font.pixelSize: 20
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Timer {
        id: clockTimer
        repeat: true
        running: true
        interval: 1000
        onTriggered: root.text = Qt.formatTime(new Date(), "hh") + "\n" + Qt.formatTime(new Date(), "mm")
    }
}

