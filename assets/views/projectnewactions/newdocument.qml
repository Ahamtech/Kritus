import bb.cascades 1.4

Page {
    titleBar: TitleBar {
        title: qsTr("Create a new document")
    }
    Container {
        rightPadding: ui.du(2)
        leftPadding: ui.du(2)
        topPadding: ui.du(2)
        CheckBox {
            text: "Client Visisble"
            id: client
            onCheckedChanged: {
                console.log(checked)
            }
        }
        TextField {
            hintText: qsTr("Untitled document")
            id: title
        }
        TextArea {
            hintText: qsTr("Type your document")
            autoSize.maxLineCount: 10
            id: des
        }
    }
    actions: [
        ActionItem {
            imageSource: "asset:///images/BBicons/ic_done.png"
            ActionBar.placement: ActionBarPlacement.Signature
            title: qsTr("Save")
            onTriggered: {
                sendData()
            }
        }
    ]
    function sendData(){
        var doc = new XMLHttpRequest();
        var url = activeproject['url'].replace('.json', "/documents.json") 
        console.log(activeproject['url'])
        var param  = { "title": title.text , "content" :des.text, "private": client.checked}
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
