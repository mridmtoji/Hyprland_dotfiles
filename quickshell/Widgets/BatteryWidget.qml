import QtQuick
import qs.Services 
import qs.Widgets 

Rectangle {

    width: batteryText.implicitWidth + 24
    height: batteryText.implicitHeight + 12
    color: "#F3F3F3"
    radius: 10



    Text {
        id: batteryText
        anchors.centerIn: parent
        text: Math.round(BatteryService.percentage * 100) + "%"
        font {
            pointSize: 13
            family: "Quicksand"
            weight: Font.Medium
        }
    }
}
