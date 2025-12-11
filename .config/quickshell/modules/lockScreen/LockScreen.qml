import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Io

import qs.config
ShellRoot {

    id: root

    IpcHandler {
        target: "lockscreen"
        function lock(): void {
             console.log("Lockscreen toggled:", ShellContext.isLocked);
           ShellContext.toggleLock();
        }

    }
    LockContext {
        id: contexte

        onUnlocked: {
            
            ShellContext.toggleLock();
            }
        
        
    }

    WlSessionLock {
        id: lock
        locked: ShellContext.isLocked
        
        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: contexte
                
            }
        }
    }
}
