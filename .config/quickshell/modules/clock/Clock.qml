import Quickshell
import QtQuick
import Quickshell.Io

Text {
    id: root
    text: Qt.formatTime(new Date(), "hh") + "\n" + Qt.formatTime(new Date(), "mm")
    font.pixelSize: 20

    Timer {
	    id : clockTimer
	    repeat: true
	    running : true
	    interval: 1000
            onTriggered: root.text = Qt.formatTime(new Date(), "hh") + "\n" + Qt.formatTime(new Date(), "mm")	
    }
}
