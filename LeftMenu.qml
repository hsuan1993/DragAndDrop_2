import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Controls 1.4

Item {
    id: leftMeun
    property alias model: listView.model
    ListView{
        id:listView
        anchors.fill: parent
        delegate: list_delegate

    }


    Component{
            id:list_delegate

            Column{
                id: objColumn
                property int titleHeight: 36 *appWindow.zoomRate
                property string fontFamily: "consolas"
                property color fontColor0: "#777777"
                property color fontColor1: "#FFFFFF"
                property color fontColor2: "#CCCCCC"
                property color fontColor3: "#8ABC2F"
                property bool isChecked: false
                Component.onCompleted: {
                    for(var i = 1; i < objColumn.children.length - 1; ++i) {
                        objColumn.children[i].visible = false
                    }
                }
                MouseArea{
                    id: _ma
                    hoverEnabled: true //This property affects the containsMouse property and the onEntered, onExited and onPositionChanged signals.
                    width:listView.width
                    height: objItem.implicitHeight
                    enabled: objColumn.children.length > 2
                    onClicked: {
                        isChecked = !isChecked
                        console.log("onClicked..")
                        for(var i = 1; i < parent.children.length - 1; ++i) {
                            console.log("onClicked..i=",i)
                            parent.children[i].visible = !parent.children[i].visible
                        }

                    }
                    Column {
                        id: objItem
                        anchors.fill: parent
                        Rectangle {
                            id:group
                            width: parent.width
                            height: objColumn.titleHeight -1//25
                            color: "#30000000"
                            Item {
                                id: titleIcon
                                anchors.verticalCenter: parent.verticalCenter
                                height: parent.height *0.6
                                width: parent.height *1.4
//                                Image {
//                                    anchors.centerIn: parent
//                                    width: parent.height; height: parent.height;
//                                    fillMode: Image.PreserveAspectFit
//                                    source: {
//                                        if (objColumn.isChecked) {
//                                            if(_ma.containsMouse) {
//                                                return "qrc:/image/LeftMenu.Reduce.Over.png"
//                                            } else {
//                                                return "qrc:/image/LeftMenu.Reduce.Nomal.png"
//                                            }
//                                        } else {
//                                            if(_ma.containsMouse) {
//                                                return "qrc:/image/LeftMenu.Add.Over.png"
//                                            } else {
//                                                return "qrc:/image/LeftMenu.Add.Nomal.png"
//                                            }
//                                        }
//                                    }
//                                }
                            }


                            Text{
                                text: groupName

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: -1
                                anchors.left: titleIcon.right
                                font.pixelSize: Math.floor(parent.height *0.55)
                                font.family: objColumn.fontFamily
                                color: (_ma.containsMouse)? objColumn.fontColor3: objColumn.fontColor2
                            }
                            Item {
                                id: titleIcon2
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                height: parent.height
                                width: parent.height *1.4
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.verticalCenterOffset: -1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text:(objColumn.isChecked)?"\u25bc": "\u25c0"
                                    font.family: "Arial"
                                    font.pixelSize: Math.floor(parent.height *0.55)
                                    color: (_ma.containsMouse)? "#8ABC2F": "#CCCCCC"
                                }
                            }
                        }
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "black"
                        }
                    }
                }
                Repeater {

                   model: subNode
                    Column{
                        id: subObjColumn
                        property bool subIsChecked: false
                        Component.onCompleted: {
                            for(var i = 1; i < subObjColumn.children.length - 1; ++i) {
                                subObjColumn.children[i].visible = false
                            }
                        }
                        Item {
                            id:toggleModel
                            width: listView.width
                            height: subObjItem.implicitHeight
                            property int settingPageHeight: 20
                            property int cellHeight: 36 *appWindow.zoomRate


                            Column {
                                id: subObjItem
                                Rectangle{
                                    id: sub
                                    width: toggleModel.width
                                    height: toggleModel.cellHeight -1
                                    color: "#10000000"
                                    y:0

                                    Item {
                                        id: tile
                                        width: parent.width
                                        height: parent.height
                                        Drag.keys: [ "Qt" ]
                                        Drag.active: ma_2.drag.active
                                        Drag.hotSpot.x: ma_2.mouseX
                                        Drag.hotSpot.y: ma_2.mouseY

                                        property int _target: index
                                        Drag.mimeData: {"target":index}
                                        Drag.supportedActions: Qt.CopyAction

                                        MouseArea {
                                            id: ma_2
                                            width: parent.width
                                            height: parent.height

                                            drag.target: tile
                                            onReleased: {
                                                tile.Drag.drop();
                                                tile.x = 0;
                                                tile.y = 0;
                                            }

                                        }

                                        Item {
                                            id:cellIcon
                                            height: parent.height *0.6
                                            width: parent.height *1.4
                                            x: parent.height
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                        Text {
                                            id:file_name
                                            text:fileName
                                            anchors.left: cellIcon.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.verticalCenterOffset: -1
                                            font.family: objColumn.fontFamily
                                            font.pixelSize: Math.floor(parent.height *0.55)
                                            color:   objColumn.fontColor1
                                        }
                                        states: State {
                                            when: ma_2.drag.active
                                            ParentChange { target: tile; parent: sub }
                                            AnchorChanges { target: tile; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
                                        }

                                    }
  /*
                                    MouseArea {
                                        id: ma_2
                                        width: parent.width
                                        height: parent.height

                                        drag.target: tile
                                        onReleased: {
                                            tile.Drag.drop();
                                            tile.x = 0;
                                            tile.y = 0;
                                        }

                                        Item {
                                            id: tile
                                            width: parent.width
                                            height: parent.height
                                            Drag.keys: [ "Qt" ]
                                            Drag.active: ma_2.drag.active
                                            Drag.hotSpot.x: 32
                                            Drag.hotSpot.y: 32

                                            Item {
                                                id:cellIcon
                                                height: parent.height *0.6
                                                width: parent.height *1.4
                                                x: parent.height
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                            Text {
                                                id:file_name
                                                text:fileName
                                                anchors.left: cellIcon.right
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.verticalCenterOffset: -1
                                                font.family: objColumn.fontFamily
                                                font.pixelSize: Math.floor(parent.height *0.55)
                                                color:   objColumn.fontColor1
                                            }
                                            states: State {
                                                when: ma_2.drag.active
                                                ParentChange { target: tile; parent: sub }
                                                AnchorChanges { target: tile; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
                                            }
                                        }
                                    }
*/
                                    Image {
                                        id:settingButton
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.topMargin: 2
                                        anchors.bottomMargin: 2
                                        width:height
                                        //source:(isSetting | settingMouseArea.containsMouse)? "../image/Schedule.Setting.Button.Nomal.png":"../image/Schedule.Setting.Button.Disable.png"
                                        property bool isSetting: false

                                        MouseArea{
                                            id:settingMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: {
                                                settingButton.isSetting = !settingButton.isSetting;
                                            }
                                        }
                                    }
                                }
                                Rectangle{
                                    id: propertyRect
                                    width: toggleModel.width
                                    height: toggleModel.settingPageHeight
                                    color: "#000000"
                                    visible: settingButton.isSetting
                                    Text {
                                          anchors.fill: parent
                                          anchors.leftMargin: 2
                                          anchors.rightMargin: 2
                                          font.pixelSize: 10
                                          font.bold: false
                                          anchors.verticalCenter: parent.verticalCenter
                                          color: "white"
                                          text: path
                                          verticalAlignment: Text.AlignVCenter
                                          horizontalAlignment: Text.AlignLeft

                                    }

                                }
                                Rectangle{
                                    width: toggleModel.width
                                    height: 1
                                    color: "black"
                                }
                                Text {
                                    id:videoIsChecked
                                    property bool videoIsChecked: fileIsChecked
                                    text:fileIsChecked
                                    visible:false
                                }
                            }
                        }




                   }

                }
            }

        }
}

// videoList_Live END
