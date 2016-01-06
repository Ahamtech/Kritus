import bb.cascades 1.4
import bb.system 1.2
import "../js/moment.js" as Moment

Page {
    titleBar: TitleBar {
        title: "Files"
    }
    onCreationCompleted: {
        getAttachments()
    }
    Container {
        topPadding: 20
        leftPadding: 20
        rightPadding: 20
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        Container { //details container
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                //                Label {
                //                    opacity: 0.7
                //                    text: qsTr("From the project :")
                //
                //                }

            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    Label {
                        text: "Uploaded by :"
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 7
                        opacity: .5
                    }
                }
                Container {
                    Label {
                        id: attachmentcreator
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 7
                        opacity: .5
                    }
                }
            }
        }
        Container {
            Label {
                id: attachmnetfilename
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 7
                opacity: 1
            }
        }
        Divider {

        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            Label {
                text: "Discuss"
                textStyle.fontSize: FontSize.Medium
                textStyle.fontWeight: FontWeight.W200
                horizontalAlignment: HorizontalAlignment.Fill
            }
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill

            ListView {
                id: commentslist

                listItemComponents: [
                    ListItemComponent {
                        type: ""
                        CustomListItem {
                            CustomComment {
                                title: ListItemData.content
                                time: Moment.moment(ListItemData['created_at']).format("lll")
                                user: ListItemData.creator.name
                                horizontalAlignment: HorizontalAlignment.Fill
                            }
                        }
                    }
                ]
                dataModel: ArrayDataModel {

                }
                horizontalAlignment: HorizontalAlignment.Fill
            }
        }
    }

    actions: [
        DeleteActionItem {
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
    function getAttachments() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        console.log("add usl " + activeitem)
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    var d = JSON.parse(doc.responseText)
                    //                    for (var i = 0; i < d.attachments.length; i ++) {
                    //                        console.log(JSON.stringify(d.attachments[i]))
                    //                    }
                    //                    for (var i = 0; i < d.comments.length; i ++) {
                    //                        console.log(JSON.stringify(d.comments[i]))
                    //                    }
                    render(d)
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
    function render(data) {
        if (data.attachments.length > 0) {
            attachmentcreator.text = data.attachments[0].creator.name
            attachmnetfilename.text = data.attachments[0].name
        } else {
            titleBar.title = "This file is been deleted"
        }
    }
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
                    getAttachments()
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
}