import bb.cascades 1.4
import bb.system 1.2

import "../js/moment.js" as Moment

Page {
    onCreationCompleted: {
        getData()
    }
    titleBar: TitleBar {
        title: qsTr("To-do")
    }
    Container {
        leftPadding: 20
        rightPadding: 20

        Container {
            topPadding: 20
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    Label {
                        //                        text: "From the To-do List: "
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 5
                        opacity: .5
                    }
                }
                Container {
                    Label { //project id here
                        //                        text: "project name"
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 5
                        opacity: .5
                    }
                }

            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    leftPadding: 10
                    scaleX: .7
                    scaleY: .7
                    CheckBox {
                        id: checking
                        onCheckedChanged: {
                            completed()
                        }
                    }
                }
                Label { //todo id here
                    //                    text: "to-do name"
                    id: content
                }
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    rightPadding: 5
                    Label {
                        id: assigne
                        //                        text: "assigned to"
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 5
                        opacity: .5
                    }
                }

                Container {
                    leftPadding: 5
                    Label { // due date id here
                        id: due
                        //                        text: "due date"
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 5
                        opacity: .5
                    }
                }
            }
            Divider {

            }
            Container {
                Label {
                    text: "Discuss this todo"
                    textStyle.fontSize: FontSize.PointValue
                    textStyle.fontSizeValue: 6
                }
            }
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
    function getData() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    var d = JSON.parse(doc.responseText)
                    console.log(doc.responseText)
                    content.text = d.content
                    if(d.assignee)
                        assigne.text = d.assignee.name
                    checking.setChecked(d.completed)
                    if(d['due_at'])
                        due.text = d['due_at']
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
    function completed() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        var param = {
            "completed": checking.checked
        }
        console.log("Complted + " + url)
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    var d = JSON.parse(doc.responseText)
                    console.log(doc.responseText)
                    content.text = d.content
                    if(d.assignee)
                        assigne.text = d.assignee.name
                    checking.setChecked(d.completed)
                    if(d['due_at'])
                        due.text = d['due_at']
                    commentslist.dataModel.clear()
                    commentslist.dataModel.append(d.comments)
                } else {
                    console.log(doc.status + doc.responseText + url)
                    console.log(JSON.stringify(param))
                }
            }
        }
        doc.open("put", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json ; charset=utf-8");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send(JSON.stringify(param));
    }
}
