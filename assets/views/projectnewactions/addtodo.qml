import bb.cascades 1.4

Page {
    titleBar: TitleBar {
        title: qsTr("Add a to-do list")
    }
    Container {
        rightPadding: ui.du(2)
        leftPadding: ui.du(2)
        topPadding: ui.du(2)
        
        Label {
            text: qsTr("List Title")
            textStyle.fontSize: FontSize.Large
            textStyle.fontWeight: FontWeight.Normal
            textStyle.fontStyle: FontStyle.Italic
            
        }
        TextField {
            hintText: qsTr("Enter list title")
            id: title
        }
        Label {
            text: qsTr("Description")
            textStyle.fontSize: FontSize.Large
            textStyle.fontWeight: FontWeight.Normal
            textStyle.fontStyle: FontStyle.Italic
            
        }
        TextArea {
            hintText: qsTr("Optional")
            id: des
            autoSize.maxLineCount: 5

        }
        CheckBox {
            text: "Client Visisble"
            id: client
            onCheckedChanged: {
                console.log(checked)
            }
            visible: false
        }
    }
    actions: [
        ActionItem {
            imageSource: "asset:///images/BBicons/ic_done.png"
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
                sendData()
            }
        }
    ]
    function sendData(){
        var doc = new XMLHttpRequest();
        var url = activeproject['url'].replace('.json', "/todolists.json") 
        console.log(activeproject['url'])
        var param  = { "name": title.text , "description" :des.text, "private": client.checked}
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 201) {
                    project_navigation.pop()
                } else {
                    console.log(doc.status + doc.responseText + url)
                    console.log(JSON.stringify(param))
                }
            }
        }
        doc.open("post", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json ; charset=utf-8");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send(JSON.stringify(param));
    }
}
