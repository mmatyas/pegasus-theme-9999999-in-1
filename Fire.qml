import QtQuick 2.0

AnimatedSprite {
    source: "assets/fire.png"
    frameWidth: 14
    frameHeight: 14
    frameCount: 2

    frameDuration: 90

    smooth: false
    interpolate: false

    width: scaled(45)
    height: width
}
