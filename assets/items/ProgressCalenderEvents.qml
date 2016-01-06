import bb.cascades 1.4
import bb.system 1.2
import "../js/moment.js" as Moment
Page {
    onCreationCompleted: {
        getData()
    }
    titleBar: TitleBar {
        title: "Event"
    }

    Container {
        topPadding: 20
        leftPadding: 20
        rightPadding: 20
        Container { //details container
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            Container {
                Label {
                    id: timer
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.Bold
                }
            
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Label {
                    opacity: 0.7
                    id: title
                }
            }

            
            Container {
                Label {
                    id: desc
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.W300
                }

            }
            

        }
        Divider {

        }
        Container {
            bottomPadding: ui.du(1.0)
            Label {
                text: "Discuss"
                textStyle.fontSize: FontSize.Medium
                textStyle.fontWeight: FontWeight.W200
            }
        }
        ListView {
            id: commentslist

            listItemComponents: ListItemComponent {
                CustomListItem {
                    CustomComment {
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
                    title.text = d.summary
                    desc.text = d.description
                    editfield.text = d.summary
                    editcontent.text = d.description
                    timer.text = Moment.moment(d['starts_at']).format("ll")
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
            "summary": editfield.text,
            "description": editcontent.text
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