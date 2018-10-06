import QtQuick 2.6
import QtGraphicalEffects 1.0

Text {
    font.family: "Arcade Classic"
    font.pixelSize: scaled(22)
    font.capitalization: Font.AllUppercase
    color: "#fff"

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: scaled(4)
        verticalOffset: scaled(1)
        radius: 0
        samples: 0
    }
}
