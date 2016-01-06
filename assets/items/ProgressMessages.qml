import bb.cascades 1.4
import bb.system 1.2
import "../js/moment.js" as Moment

Page {
    onCreationCompleted: {
        getData()
    }
    titleBar: TitleBar {
        title: "Messages"
    }
    Container {
        leftPadding: 30
        rightPadding: 30
        topPadding: 20
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            Label {
                id: title

            }
            ScrollView {

                Label {
                    id: des
                    horizontalAlignment: HorizontalAlignment.Fill
                    textFormat: TextFormat.Html
                    multiline: true
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
            ListView {
                id: commentslist

                listItemComponents: ListItemComponent {
                    CustomListItem {
                        CustomComment {
                            title: ListItemData.content
                            time: Moment.moment(ListItemData['created_at']).format("lll")
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
            "subject": editfield.text,
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
    function getData() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    var info = JSON.parse(doc.responseText)
                    title.text = info.subject
                    if (info.content)
                        des.text = info.content
                    editfield.text = info.subject
                    if (info.content)
                        editcontent.text = info.content
                    commentslist.dataModel.clear()
                    commentslist.dataModel.append(info.comments)
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
}
