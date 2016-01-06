import bb.cascades 1.4
import bb.system 1.2
import "../js/moment.js" as Moment

Page {
    onCreationCompleted: {
        getData()
    }
    titleBar: TitleBar {
        title: "Document"

    }

    Container {
        leftPadding: ui.du(2)
        rightPadding: ui.du(2)
        topPadding: ui.du(2)
        bottomPadding: ui.du(2)
        Container {
            minHeight: ui.du(40)
            background: Color.create("#ffffffca")
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            Container {
                leftPadding: 20
                rightPadding: 20
                topPadding: 20
                bottomPadding: 20
                verticalAlignment: VerticalAlignment.Fill
                Container {
                    Label {
                        horizontalAlignment: HorizontalAlignment.Center
                        id: docname
                        //                        text: "Doc name"
                        textStyle.color: Color.Blue
                        opacity: .5
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontWeight: FontWeight.Bold
                    }
                }
                Container {
                    TextArea {
                        id: content
                        //text: "content"
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontWeight: FontWeight.W200
                backgroundVisible: false
                        textFormat: TextFormat.Html
                    }
                }
            }
        }
        Container {
            Container {

                topPadding: 10
                Label {
                    id: user
                    //                    text: "user"
                }

            }
            Divider {

            }
            Container {

                Label {
                    text: "Discussions on this Document"
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.W200
                }
            }
            Divider {

            }
            ListView {
                horizontalAlignment: HorizontalAlignment.Fill
                id: commentslist

                listItemComponents: ListItemComponent {
                    CustomListItem {
                        CustomComment {
                            horizontalAlignment: HorizontalAlignment.Fill
                            title: ListItemData.content
                            time: Moment.moment(ListItemData['updated_at']).format("lll")
                            user: ListItemData.creator.name
                        }
                    }
                }
                dataModel: ArrayDataModel {

                }
            }
        }

    }
    actions: [
        ActionItem {
            title: qsTr("Edit")
            imageSource: "asset:///images/BBicons/ic_edit.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                edit.open()
            }

        },
        ActionItem {
            title: qsTr("Delete")
            imageSource: "asset:///images/BBicons/ic_delete.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                deletedil.show()

            }
        },
        ActionItem {
            title: qsTr("Add Comment")
            imageSource: "asset:///images/BBicons/ic_compose.png"
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
                commentsheet.open()
            }
        }
    ]
    attachedObjects: [
        CommentsSheet {
            id: commentsheet
        },
        SystemDialog {
            id: deletedil
            title: "Delete discussion"
            body: "Are you sure you want to delete this ?"
            confirmButton.label: "Yes"
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    deleteData()
                }
            }
        },
        Sheet {
            id: edit
            content: Page {
                titleBar: TitleBar {
                    title: "Comment"
                    dismissAction: ActionItem {
                        title: "close"
                        onTriggered: {
                            edit.close()
                        }
                    }
                    acceptAction: ActionItem {
                        title: "Save"
                        onTriggered: {
                            updatedocument()
                        }
                    }
                }
                Container {

                    TextField {
                        id: editfield
                    }
                    TextArea {
                        id: editcontent
                        preferredHeight: ui.du(60)
                    }
                }
            }
        }
    ]
    function comment(text) {
        var doc = new XMLHttpRequest();
        var url = activeitem.replace('.json', "/comments.json")
        var param = {
            "content": text
        }
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 201) {
                    commentsheet.close()
                    getData()
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
    function getData() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    var d = JSON.parse(doc.responseText)
                    docname.text = d.title
                    if(d.content)
                        content.text = "<html>"+d.content+"</html>"
                    editfield.text = d.title
                    
                    editcontent.text = d.content
                    user.text = d.creator.name + " updated at " + Moment.moment(d['updated_at']).format("lll")
                    commentslist.dataModel.clear()
                    commentslist.dataModel.append(d.comments)
                } else {

                    console.log(doc.status + doc.responseText)
                }
            }
        }
        doc.open("get", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send();
    }
    function deleteData() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 204) {
                    this.pop()
                } else {

                    console.log(doc.status + doc.responseText)
                }
            }
        }
        doc.open("delete", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send();
    }
    function updatedocument() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        var param = {
            "title": editfield.text,
            "content": editcontent.text
        }
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    edit.close()
                    getData()
                } else {
                    console.log(doc.status + doc.responseText + url)
                    console.log(JSON.stringify(param))
                }
            }
        }
        doc.open("PUT", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json ; charset=utf-8");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send(JSON.stringify(param));
    }
}
