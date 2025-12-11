import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls

ShellRoot {
    id: root

    LockContext {
        id: context

        onUnlocked: {
            console.log("Unlock successful, quitting")
            lock.locked = false
            Qt.quit()
        }
        
        onFailed: {
            console.log("Unlock failed")
        }
    }

    WlSessionLock {
        id: lock
        locked: true
        
        onLockStateChanged: {
            console.log("Lock state changed:", lockState)
        }
        
        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: root.context
                
                Component.onCompleted: {
                    console.log("LockSurface context:", context)
                }
            }
        }
    }
}
