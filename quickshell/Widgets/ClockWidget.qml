import QtQuick
import qs.Services 
import qs.Widgets 

Rectangle {

    width: timeText.implicitWidth + 24
    height: timeText.implicitHeight + 12
    color: "#F3F3F3"
    radius: 10

    Text {
        id: timeText
        anchors.centerIn: parent
        text: TimeService.time
        font {
            pointSize: 13
            family: "Quicksand"
            weight: Font.Medium
        }
    }
}
