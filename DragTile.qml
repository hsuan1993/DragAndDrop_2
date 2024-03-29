import QtQuick 2.0

//! [0]
Item {
    id: root
    property string colorKey

    width: 64; height: 64

    MouseArea {
        id: mouseArea

        width: 64; height: 64
        anchors.centerIn: parent

        drag.target: tile

        onReleased: parent = tile.Drag.target !== null ? tile.Drag.target : root

        Rectangle {
            id: tile

            width: 64; height: 64
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            color: colorKey

            Drag.keys: [ colorKey ]
            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: 32
            Drag.hotSpot.y: 32
//! [0]
            Text {
                anchors.fill: parent
                color: "white"
                font.pixelSize: 48
                text: modelData + 1
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
//! [1]
            states: State {
                when: mouseArea.drag.active
                ParentChange { target: tile; parent: root }
                AnchorChanges { target: tile; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
            }

        }
    }
}
//! [1]

