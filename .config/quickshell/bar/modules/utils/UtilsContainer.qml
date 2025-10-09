import Quickshell
import QtQuick
import QtQuick.Layouts
import "power_profile"

Rectangle {
	id : container
	height : 90
	width : 30
	radius: 30
        color: "#2a2b36"

	ColumnLayout {
		spacing : 5

		PowerProfile {
			Layout.alignment: Qt.AlignHCenter
			Layout.fillWidth: true

		}


	}
}
