import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {
    id: root
    
    implicitWidth: workspaceRow.implicitWidth + 16
    implicitHeight: workspaceRow.implicitHeight
    
    property int maxWorkspaces: 10
    property color activeColor: "#E0D9D9"
    property color focusedColor: "#222831"
    property color urgentColor: "#BF616A"
    property color textColor: "#ECEFF4"
    property int spacing: 8
    property int buttonWidth: 40
    property int buttonHeight: 28
    property int cornerRadius: 8
    
    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: root.spacing
        
        Repeater {
            model: {
                // Get all workspaces and filter to show only active ones (with windows)
                let workspaces = Hyprland.workspaces.values
                let activeWorkspaces = []
                
                for (let i = 0; i < workspaces.length; i++) {
                    let ws = workspaces[i]
                    // Include workspace if it has windows or is currently focused
                    if ((ws.toplevels?.values?.length > 0) || ws.focused) {
                        activeWorkspaces.push(ws)
                    }
                }
                
                // Sort by workspace ID
                activeWorkspaces.sort((a, b) => a.id - b.id)
                
                // Limit to maxWorkspaces
                return activeWorkspaces.slice(0, root.maxWorkspaces)
            }
            
            Rectangle {
                id: workspaceButton
                
                required property var modelData
                
                Layout.preferredWidth: root.buttonWidth
                Layout.preferredHeight: root.buttonHeight
                radius: root.cornerRadius
                
                property var workspace: modelData
                property int workspaceId: workspace.id
                property bool isFocused: workspace.focused ?? false
                property bool isUrgent: workspace.urgent ?? false
                
                color: {
                    if (isUrgent) return root.urgentColor
                    if (isFocused) return root.focusedColor
                    return root.activeColor
                }
                
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
                
                Text {
                    anchors.centerIn: parent
                    text: workspaceButton.workspaceId
                    color: root.textColor
                    font {
                        pointSize: 13
                        family: "Quicksand"
                        weight: Font.Medium
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        Hyprland.dispatch(`workspace ${workspaceButton.workspaceId}`)
                    }
                    
                    onEntered: {
                        parent.scale = 1.1
                    }
                    
                    onExited: {
                        parent.scale = 1.0
                    }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }
    }
    
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            Hyprland.refreshWorkspaces()
            // Force model update
            workspaceRow.children[0].model = workspaceRow.children[0].model
        }
    }
    
    Connections {
        target: Hyprland
        
        function onRawEvent(event) {
            // Refresh on workspace-related events
            if (event.name === "workspace" || 
                event.name === "createworkspace" ||
                event.name === "destroyworkspace" ||
                event.name === "openwindow" ||
                event.name === "closewindow" ||
                event.name === "focusedmon" ||
                event.name === "moveworkspace" ||
                event.name === "urgent") {
                Hyprland.refreshWorkspaces()
            }
        }
    }
}
