import Quickshell
import qs.Services
import qs.Widgets 

Scope {

    Variants {
        model: Quickshell.screens
        
        PanelWindow {

            required property var modelData
            screen: modelData

            anchors {
                top: true 
                left: true
                right: true
            }

            implicitHeight: 35

            ClockWidget {
                anchors.centerIn: parent
            }

            BatteryWidget {
                anchors.left: parent.left
            }
            WorkspaceWidget {
                anchors {
                    right: parent.right 
                    verticalCenter: parent.verticalCenter
                }
            }
        }

    }
}
