import QtQuick 2.6

Text {
    id: root

    font.family: "Arcade Classic"
    font.pixelSize: scaled(22)
    font.capitalization: Font.AllUppercase
    color: "#fff"

    Text {
        text: root.text
        font.family: root.font.family
        font.pixelSize: root.font.pixelSize
        font.capitalization: root.font.capitalization
        leftPadding: root.leftPadding
        width: root.width
        elide: root.elide
        color: "#000"
        z: -1

        anchors {
            left: parent.left; leftMargin: scaled(4)
            top: parent.top; topMargin: scaled(1)
        }
    }
}
