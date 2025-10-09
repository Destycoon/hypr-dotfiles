import Quickshell
import QtQuick
import Quickshell.Wayland
PanelWindow {
	id : root

	color : "transparent"

	implicitWidth : 600
	implicitHeight: 300
	
	WlrLayershell.layer: WlrLayer.Bottom

	Rectangle {
		width : parent.width
		height : parent.height

		radius : 18
		color : "#1a1b26"
		
		Column {
			id : mainCol
			spacing : 10

			anchors.centerIn: parent

			Row {
				spacing : 10
				
				Rectangle {
					width : 40
					height : 40
					radius : 8
				}
				Rectangle {
					width : 40
					height : 40
					radius : 8
				}
			}
			Row {
				spacing : 10
				
				Rectangle {
					width : 40
					height : 40
					radius : 8
				}
				Rectangle {
					width : 40
					height : 40
					radius : 8
				}
			}
		}



	}
}
