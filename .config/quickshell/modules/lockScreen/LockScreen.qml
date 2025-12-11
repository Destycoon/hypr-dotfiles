import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls

ShellRoot {
    id: root

    LockContext {
        id: contexte

        onUnlocked: {
            lock.locked = false
            Qt.quit()
        }
        
        
    }

    WlSessionLock {
        id: lock
        locked: true
        
        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: contexte
                
            }
        }
    }
}
