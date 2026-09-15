import QtQuick

Rectangle {
    Text {
        anchors.centerIn: parent
        text: Qt.formatTime(new Date(), "HH:mm")
        font.pixelSize: 32
    }
}
