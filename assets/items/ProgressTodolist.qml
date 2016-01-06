import bb.cascades 1.4
import bb.system 1.2

import "../js/moment.js" as Moment

Page {
    onCreationCompleted: {
        getData()
        Qt.completeditems = completeditems 
    }
    titleBar: TitleBar {
        title: qsTr("To-do list")
    }

    Container {
        rightPadding: ui.du(2)
        leftPadding: ui.du(2)
        topPadding: ui.du(2)

        Container {
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Label {
                    id: timer
                    opacity: 0.7
                }
            }
            Container {
                Label {
                    horizontalAlignment: HorizontalAlignment.Center

                    id: name
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.Bold
                }
            }
            Container {
                Label {
                    id: des

                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.W200
                }
            }
            Container {
                ListView {
                    id: todolist
                    onTriggered: {
                        Qt.onEventTriggredApp(dataModel.data(indexPath))
                    }
                    listItemComponents: [
                        ListItemComponent {
                            CustomListItem {
                                CustomTodoListItem {
                                    listname: ListItemData.content
                                    onCompleted: {
                                        Qt.completeditems(ListItemData['url'],true)
                                    }
                                    onIncompleted: {
                                        Qt.completeditems(ListItemData['url'],false)
                                    }
                                }
                            }
                        }
                    ]
                    dataModel: ArrayDataModel {

                    }
                }
            }

        }
    }
    actions: [
        ActionItem {
            title: qsTr("Add To-do")
            imageSource: "asset:///images/BBicons/ic_compose.png"
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
                addtodo.show()
            }
        },
        DeleteActionItem {
            title: qsTr("Delete")
            imageSource: "asset:///images/BBicons/ic_delete.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                deletedil.show()

            }
        }
//        ActionItem {
//            title: qsTr("Add Comment")
//            imageSource: "asset:///images/BBicons/ic_compose.png"
//            ActionBar.placement: ActionBarPlacement.Signature
//            onTriggered: {
//                commentsheet.open()
//            }
//        }
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
        SystemPrompt {
            id: addtodo
            title: "Add a to-do"
            body: ""
            inputField.emptyText: "Enter title of to-do list"
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    createtodo(inputFieldTextEntry())
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
                    name.text = d.name
                    timer.text = Moment.moment(d['updated_at']).format("lll")
                    todolist.dataModel.clear()
                    todolist.dataModel.append(d.todos['remaining'])
                    des.text = d.description
                    //                    commentslist.dataModel.clear()
                    //                    commentslist.dataModel.append(d.comments)
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
    function deleteData() {
        var doc = new XMLHttpRequest();
        var url = activeitem
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 204) {

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

    function createtodo(text) {
        var doc = new XMLHttpRequest();
        var url = activeitem.replace('.json', "/todos.json")
        var param = {
            "content": text
        }
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 201) {
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
    function completeditems(comurl,item) {
        var doc = new XMLHttpRequest();
        var url = comurl
        var param = {
            "completed": item
        }
        console.log("Complted + " + comurl + " " + item)
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    getData()
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
