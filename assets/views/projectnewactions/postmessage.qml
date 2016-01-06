import bb.cascades 1.4

Page {
    onCreationCompleted: {
        console.log(JSON.stringify(people))
    }
    titleBar: TitleBar {
        title: qsTr("Post a message")
    }
    Container {
        rightPadding: ui.du(2)
        leftPadding: ui.du(2)
        topPadding: ui.du(2)
        TextArea {
            id: title
            hintText: qsTr("Enter the subject of the message...")
            autoSize.maxLineCount: 2
            input.submitKey: SubmitKey.Next
        }
        TextArea {
            id: des
            hintText: qsTr("Type your message here...")
            autoSize.maxLineCount: 7
            input.submitKey: SubmitKey.EnterKey
        }
        Label {
            multiline: true
            text: qsTr("These recipients will get an email about your message")
        }
    }
    actions: [
        ActionItem {
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///images/thumbnails/bar_chats.png"
            title: qsTr("Post Message")
            onTriggered: {
                sendData()
            }
        }
    ]
    function sendData(){
        var doc = new XMLHttpRequest();
        var url = activeproject['url'].replace('.json', "/messages.json") 
        console.log(activeproject['url'])
        var param  = { subject: title.text , content :des.text}
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
