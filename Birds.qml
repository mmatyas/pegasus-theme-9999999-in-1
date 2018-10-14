import QtQuick 2.0

Item {
    id: root

    readonly property int frameWidth: 24
    readonly property int frameHeight: 8
    readonly property int frameCount: 4

    readonly property int birdHeight: scaled(26)
    readonly property int birdWidth: birdHeight / frameHeight * frameWidth

    readonly property int movementAreaW: width - birdWidth
    readonly property int movementAreaH: height - birdHeight

    Repeater {
        model: 2
        // NOTE: SpriteSequence may be better here, but its smoothing cannot be controlled...
        delegate: AnimatedSprite {
            id: bird

            property int startX: 0
            property int startY: 0
            property int targetX: 0
            property int targetY: 0
            readonly property int distanceX: Math.abs(startX - targetX)
            readonly property int distanceY: Math.abs(startY - targetY)

            function bounce(min, max, current) {
                if (current <= min)
                    return max;
                if (max <= current)
                    return min;

                return Math.random() > 0.5 ? min : max;
            }
            function pickNewDest() {
                startX = x;
                startY = y;
                targetX = bounce(0, root.movementAreaW, startX);
                targetY = bounce(0, root.movementAreaH, startY);
                x = targetX;
                y = targetY;
            }
            Component.onCompleted: pickNewDest()

            x: Math.random() * root.movementAreaW
            y: Math.random() * root.movementAreaH

            Behavior on x { PropertyAnimation {
                duration: distanceX * 40
                onRunningChanged: if (!running) pickNewDest()
            }}
            Behavior on y { PropertyAnimation {
                duration: distanceY * 80
                onRunningChanged: if (!running) pickNewDest();
            }}

            source: "assets/birdB.png"
            frameWidth: root.frameWidth
            frameHeight: root.frameHeight
            frameCount: (startY < targetY) ? 1 : root.frameCount
            frameDuration: 200

            smooth: false
            interpolate: false

            width: birdWidth
            height: birdHeight

            transform: Rotation {
                origin.x: birdWidth / 2
                axis.y: 1
                axis.z: 0
                angle: (bird.startX < bird.targetX) ? 0 : 180
            }
        }
    }
}
