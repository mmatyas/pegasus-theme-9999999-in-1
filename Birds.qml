import QtQuick 2.0

// NOTE: SpriteSequence would be better below,
// but its smoothing cannot be controlled...
Item {
    id: root

    readonly property int frameCount: 4
    readonly property int birdHeight: scaled(26)
    readonly property int birdWidth: birdHeight / bird1.frameHeight * bird1.frameWidth
    readonly property real birdSpeed: scaled(2)

    Component.onCompleted: {
        var birds = [bird1, bird2];
        for (var i = 0; i < birds.length; i++) {
            birds[i].x = Math.random() * (root.width - birds[i].width);
            birds[i].y = Math.random() * (root.height - birds[i].height);
            birds[i].vel = [Math.random() > 0.5 ? 1 : -1, Math.random() > 0.5 ? 0.4 : -0.4];
            birds[i].rotAngle = 90 + birds[i].vel[0] * -90;
            birds[i].frameCount = birds[i].vel[1] < 0 ? root.frameCount : 1;
        }
        timer.start();
    }

    Timer {
        id: timer
        interval: 48
        repeat: true

        onTriggered: {
            var birds = [bird1, bird2];
            for (var i = 0; i < birds.length; i++) {

                birds[i].x += birds[i].vel[0] * birdSpeed;
                birds[i].y += birds[i].vel[1] * birdSpeed;

                if (birds[i].x < 0) {
                    birds[i].x = 0;
                    birds[i].vel[0] = -birds[i].vel[0];
                    birds[i].rotAngle = 0;
                }
                if (birds[i].x + birds[i].width > root.width) {
                    birds[i].x = root.width - birds[i].width;
                    birds[i].vel[0] = -birds[i].vel[0];
                    birds[i].rotAngle = 180;
                }
                if (birds[i].y < 0) {
                    birds[i].y = 0;
                    birds[i].vel[1] = -birds[i].vel[1];
                    birds[i].frameCount = 1;
                }
                if (birds[i].y + birds[i].height > root.height) {
                    birds[i].y = root.height - birds[i].height;
                    birds[i].vel[1] = -birds[i].vel[1];
                    birds[i].frameCount = root.frameCount;
                }
            }
        }
    }

    AnimatedSprite {
        id: bird1

        property var vel: [0,0] // velocity vector
        property real rotAngle: 0 // either 0 (facing right) or 180 (left)

        source: "assets/birdB.png"
        frameWidth: 24
        frameHeight: 8
        frameCount: 1
        frameDuration: 150
        smooth: false
        interpolate: false

        width: birdWidth
        height: birdHeight

        transform: Rotation {
            origin.x: birdWidth / 2
            axis.y: 1
            axis.z: 0
            angle: bird1.rotAngle
        }
    }
    AnimatedSprite {
        id: bird2

        property var vel: [0,0]
        property real rotAngle: 0

        source: bird1.source
        frameWidth: bird1.frameWidth
        frameHeight: bird1.frameHeight
        frameCount: 1
        frameDuration: bird1.frameDuration
        smooth: false
        interpolate: false

        width: birdWidth
        height: birdHeight

        transform: Rotation {
            origin.x: birdWidth / 2
            axis.y: 1
            axis.z: 0
            angle: bird2.rotAngle
        }
    }
}
