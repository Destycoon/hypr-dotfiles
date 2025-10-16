import Quickshell
import QtQuick
import qs.utils
import QtQuick.Layouts
import "modules"
import Quickshell.Io

PanelWindow {
    id: dashboard

    color: "transparent"

    implicitWidth: 600
    implicitHeight: 300

    IpcHandler {
        target: "dashboard"

        function toggle(): void {
            dashboard.visible = !dashboard.visible;
        }
    }
    Rectangle {
        width: parent.width
        height: parent.height
        radius: 28
        color: Colors.bg

        GridLayout {
            columnSpacing: 5
            rowSpacing: 5
            columns: 4
		
	    Player{
		    
	    }
        }
    }
}
