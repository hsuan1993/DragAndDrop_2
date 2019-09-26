import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12



Window {
    id: appWindow
    visible: true
    width: 1366
    height: 768
    title: qsTr("Hello World")
    property real zoomRate: Math.min(width /1920, height /1080)
    property variant channelSelected: [0,0,0,0,0,0,0,0,0]


    Rectangle
    {
        id: line1
        y: parent.height *60 /1080; width: parent.width; height: 1; color: "#000000";
    }

    Rectangle
    {
        id: line2
        x: parent.width *300 /1920; height: parent.height; width: 1; color: "#000000";
    }
    Rectangle
    {
        id: bgFiller3
        anchors.left: parent.left; anchors.right: line2.left; anchors.top: line1.bottom; anchors.bottom: parent.bottom;
        color: "#2F2F2F";
    }
    Rectangle
    {
        id: bgFiller4
        anchors.left: line2.right
        anchors.right: parent.right
        anchors.top: line1.bottom
        anchors.bottom: parent.bottom;
        color: "#252525";
    }

    Item {
        id:videoList_Live
        anchors.fill: bgFiller3
        LeftMenu {
            id:myTree
            anchors.fill: parent
            model: channelList
        }
        ListModel {
            id:channelList
            Component.onCompleted: {
                for (var i=0;i<9;i++) {
                    addModelData("Group 1","CH0"+(i+1),false,"rtsp://root:root@10.10.80.114:"+(554+i*2)+"/session0.mpg")
                console.log(i)
                }
            }
            function addModelData(groupName,fileName,fileIsChecked,path){
                var index = findIndex(groupName)
                if(index === -1){
                    channelList.append({"groupName":groupName,"level":0,
                                         "subNode":[{"fileName":fileName,"fileIsChecked":fileIsChecked,"path":path,"level":1,"subNode":[]}]})
                }
                else{
                    channelList.get(index).subNode.append({"fileName":fileName,"fileIsChecked":fileIsChecked,"path":path,"level":1,"subNode":[]})
                }

            }

            function findIndex(name){
                for(var i = 0 ; i < channelList.count ; ++i){
                    if(channelList.get(i).groupName === name){
                        return i
                    }
                }
                return -1
            }
        }
    }

    Item
    {
        id: gridDlg
        anchors.fill: bgFiller4
        property int contentWidth: Math.min(bgFiller4.width , bgFiller4.height*16/9)*0.98
        property int contentHeight: contentWidth *9 /16
        property int widthSpacing: bgFiller4.width -contentWidth
        property int heightSpacing: bgFiller4.height -contentHeight

        property int contentWidthSpacing: Math.min(widthSpacing *9 /16, heightSpacing) *16 /36
        property int contentHeightSpacing: contentWidthSpacing *9 /16
        property int contentMinSpacing: Math.min(contentWidthSpacing, contentHeightSpacing)

        property int contentWidth4: Math.min( (contentWidth -contentMinSpacing) *9 /16, (contentHeight -contentMinSpacing) ) *16 /18
        property int contentHeight4: contentWidth4 *9 /16
        property int contentWidth9: Math.min( (contentWidth -contentMinSpacing *2) *9 /16, (contentHeight -contentMinSpacing *2) ) *16 /27
        property int contentHeight9: contentWidth9 *9 /16
        property int contentWidth16: Math.min( (contentWidth -contentMinSpacing *3) *9 /16, (contentHeight -contentMinSpacing *3) ) *16 /36
        property int contentHeight16: contentWidth16 *9 /16


        GridLayout {
            id: grid
            width: Math.round(gridDlg.contentWidth)
            height: Math.round(gridDlg.contentHeight)
            x: Math.round(gridDlg.widthSpacing /2)
            y: Math.round(gridDlg.heightSpacing /2)
            rows: 12
            columns: 12
            property double colMulti : grid.width / grid.columns
            property double rowMulti : grid.height / grid.rows
            function prefWidth(item){
                return colMulti * item.Layout.columnSpan
            }
            function prefHeight(item){
                return rowMulti * item.Layout.rowSpan
            }
            Repeater {
                model: 4


                DropArea {
                    id: dragTarget
                    keys: [ "Qt" ]
                    property alias dropProxy: dragTarget

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.rowSpan   : {
                        if (index < 4) {
                            switch(index) {
                                case 0:
                                    return 12
                                case 1:
                                case 2:
                                case 3:
                                    return 4
                            }
                        }
                    }

                    Layout.columnSpan: {
                            if (index < 4) {
                                switch(index) {
                                case 0:
                                    return 8
                                case 1:
                                case 2:
                                case 3:
                                    return 4
                                }
                            }
                    }
                    Layout.preferredWidth  : grid.prefWidth(this)
                    Layout.preferredHeight : grid.prefHeight(this)

                    states: [
                        State {
                            when: dragTarget.containsDrag
                            PropertyChanges {
                                target: dlg
                                border.color: "grey"
                            }
                        }
                    ]
                    onDropped: {
                        if(drop.source._index >= 0)
                            channelList[drop.source._index] = dlg.targetChannel;
                        dlg.targetChannel = drop.source._target;
                        dlg.titleName = "CH0"+ (dlg.targetChannel +1);
                        channelSelected[index] = dlg.targetChannel;
                        console.log("[CW] index=",index);
                        console.log("[CW] target=",dlg.targetChannel," ch=",dlg.titleName);
                    }

                    Rectangle {
                        id: dlg
                        color: "black"
                        anchors.fill: parent
                        property int targetChannel: 0 //index
                        property string titleName: "CH0"+(targetChannel+1)


                            Item {
                                id:tile
                                width: parent.width
                                height: parent.height
                                Drag.keys: ["Qt"]
                                Drag.active: ma_3.drag.active
                                Drag.hotSpot.x: ma_3.mouseX
                                Drag.hotSpot.y: ma_3.mouseY

                                //change channel
                                property int _target: dlg.targetChannel
                                property int _index: index
                                Drag.mimeData: {"target":dlg.targetChannel,"index":index}
                                Drag.supportedActions: Qt.CopyAction

                                //remove target
                                Drag.onDragFinished: {
                                    console.log("Finish");
//                                    dlg.targetChannel=0;
//                                    dlg.titleName="CH01";
                                    //remove target code
                                }
                                //remove target -END

                                MouseArea {
                                    id: ma_3
                                    width:parent.width
                                    height: parent.height
                                    drag.target: tile
                                    onReleased: {
                                        tile.Drag.drop();
                                        tile.x = 0;
                                        tile.y = 0;
                                        //control onDragFinished method
                                        tile.Drag.dragFinished(Qt.CopyAction);


                                    }
                                 }
                                Text {
                                    id: title_txt
                                    text:dlg.titleName
                                    font.pixelSize: 30
                                    color:"white"
                                }
                                //兩個或以上的顏色無接縫混和
                                LinearGradient  {
                                    anchors.fill: title_txt
                                    source: title_txt
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "white" }
                                        GradientStop { position: 1; color: "black" }
                                    }
                                }
                                states: State {
                                    when: ma_3.drag.active
                                    ParentChange { target: tile; parent: dlg }
                                    AnchorChanges { target: tile; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
                                }
                            }

                    }
                }


            }


        }


    }

}
