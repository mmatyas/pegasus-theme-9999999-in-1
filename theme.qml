import QtQuick 2.0
import QtMultimedia 5.8


FocusScope {
    readonly property real scale: Math.min(width / 960.0, height / 720.0)
    function scaled(value) {
        return scale * value;
    }

    function zeroPad(number, width) {
        var str = number.toString();
        var strlen = str.length;
        if (strlen >= width)
            return str;

        return new Array(width - strlen + 1).join('0') + number;
    }

    Keys.onLeftPressed: api.collectionList.decrementIndex()
    Keys.onRightPressed: api.collectionList.incrementIndex()
    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isAccept(event.key)) {
            event.accepted = true;
            api.currentGame.launch();
            return;
        }
    }


    FontLoader { source: "assets/arcade-classic.ttf" }

    Audio {
        audioRole: Audio.MusicRole
        source: "assets/music.ogg"
        autoPlay: true
        loops: Audio.Infinite
    }

    Image {
        id: background

        readonly property int bgCount: 14

        source: "bg/0.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: false
    }

    Item {
        width: scaled(960)
        height: scaled(720)
        anchors.centerIn: parent

        readonly property int textHeight: collName.height

        RetroText {
            id: collName
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: api.collectionList.current.name
        }

        ListView {
            id: gamelist

            readonly property int maxVisibleLines: 16
            readonly property int leftPadding: scaled(64)
            readonly property int digitCount: api.currentCollection.gameList.count.toString().length

            height: parent.textHeight * maxVisibleLines
            anchors.top: collName.bottom
            anchors.left: parent.left
            anchors.leftMargin: scaled(180) - leftPadding
            anchors.right: parent.right
            anchors.rightMargin: scaled(160)
            clip: true

            focus: true
            keyNavigationWraps: true

            Keys.onPressed: {
                if (event.isAutoRepeat)
                    return;

                if (api.keys.isPageDown(event.key)) {
                    event.accepted = true;
                    currentIndex = Math.min(api.currentCollection.gameList.count - 1,
                                            currentIndex + maxVisibleLines);
                    return;
                }
                if (api.keys.isPageUp(event.key)) {
                    event.accepted = true;
                    currentIndex = Math.max(0, currentIndex - maxVisibleLines);
                    return;
                }
            }

            model: api.currentCollection.gameList.model
            delegate: RetroText {
                id: gametitle
                text: zeroPad(index + 1, gamelist.digitCount) + "." + modelData.title
                leftPadding: gamelist.leftPadding
                width: ListView.view.width
                elide: Text.ElideRight
            }

            highlight: Item {
                AnimatedSprite {
                    source: "assets/birdA.png"
                    frameWidth: 16
                    frameHeight: 6
                    frameCount: 4
                    frameDuration: 150

                    interpolate: false
                    smooth: false

                    height: scaled(20)
                    width: height / frameHeight * frameWidth
                }
            }
            highlightMoveDuration: 0

            onCurrentIndexChanged: {
                api.currentCollection.gameList.index = currentIndex;

                var page = Math.floor(currentIndex / maxVisibleLines);
                contentY = page * maxVisibleLines * parent.textHeight;
                background.source = "bg/%1.png".arg(page % background.bgCount);
            }
        }

        Birds {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: scaled(440)
        }
    }
}
