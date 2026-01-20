import QtQuick
import QtQuick.Layouts

Item {
    id: clockRoot
    implicitWidth: timeText.implicitWidth
    implicitHeight: timeText.implicitHeight

    property string dateTime: ""

    function updateTime() {
        dateTime = Qt.formatDateTime(new Date(), "ddd, MMM dd | HH:mm:ss");
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clockRoot.updateTime()
    }

    Text {
        id: timeText
        text: clockRoot.dateTime
        color: "#a9b1d6"
        font {
            pixelSize: 16
            family: "Comic Relief"
            bold: true
        }
        anchors.centerIn: parent
    }
}
