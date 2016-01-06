import bb.cascades 1.4
import "../js/moment.js" as Moment
page{
    property variant projectinfo
    onCreationCompleted: {
        console.log(JSON.stringify(activeproject))
        projecttitle.text = activeproject.name
        projectInfo()
        events()
    }
    actions: [
        
        ActionItem {
            title: qsTr("Post a message")
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///images/BBicons/ic_bbm.png"
            onTriggered: {
                navigationpane.push(addtaskpage.createObject())
            }
            shortcuts: [
                SystemShortcut {
                    type: SystemShortcuts.CreateNew
                }
            ]
        },
        ActionItem {
            title: qsTr("Upload a file")
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/BBicons/ic_attach.png"
            onTriggered: {
                navigationpane.push(mytasks.createObject())
            }
            shortcuts: [
                SystemShortcut {
                    type: SystemShortcuts.Forward
                }
            ]
        },
        ActionItem {
            title: qsTr("Make a to-do list")
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/BBicons/ic_done.png"
            onTriggered: {
                taskslist.visible = false
                selectionitems.visible = false
                searchcontainer.visible = true
                searchbox.requestFocus()
            }
            shortcuts: [
                SystemShortcut {
                    type: SystemShortcuts.Search
                }
            ]
        },
        ActionItem {
            title: qsTr("Write a document")
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/BBicons/ic_entry.png"
            onTriggered: {
                navigationpane.push(projectfollowers.createObject())
            }
        },
        ActionItem {
            title: qsTr("Forward an email")
            imageSource: "asset:///images/BBicons/ic_email_dk.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                navigationpane.push(projedit.createObject())
            }
            shortcuts: [
                SystemShortcut {
                    type: SystemShortcuts.Edit
                }
            ]
        },
        ActionItem {
            title: qsTr("Add an event")
            imageSource: "asset:///images/BBicons/ic_compose.png"
            onTriggered: {
                app.flushProjectTasks(activeproject)
                renderInit()
                refreshicon.enabled = false
                rotateanimate.play()
                tasks()
            }
        },
        ActionItem {
            title: qsTr("Invite a person")
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/BBicons/ic_contact.png"
            onTriggered: {
                taskslist.visible = false
                selectionitems.visible = false
                searchcontainer.visible = true
                searchbox.requestFocus()
            }
            shortcuts: [
                SystemShortcut {
                    type: SystemShortcuts.Search
                }
            ]
        }
    ]

    function events() {
        var doc = new XMLHttpRequest();
        var url = activeproject['url'].replace('.json', "/events.json")
        console.log(url)
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    console.log(doc.responseText)
                    var events = JSON.parse(doc.responseText)
                    projectactivity.dataModel.clear()
                    for (var i = 0; i < events.length; i ++) {
                        var stamp = Moment.moment(events[i]["updated_at"]).format("YYYY-MM-DD")
                        events[i].stamp = stamp
                    }
                    projectactivity.dataModel.insertList(events)
                    console.log("size data model",projectactivity.dataModel.size())

                } else {
                    
                    console.log(doc.status + doc.responseText + url)
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
    function projectInfo() {
        var doc = new XMLHttpRequest();
        var url = activeproject['url']
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    console.log(doc.responseText)
                    projectinfo = JSON.parse(doc.responseText)
                } else {
                    
                    console.log(doc.status + doc.responseText + url)
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
Container {
    Label {
        text: "hello this is john"
        
    }
    ListView {
        id: projectactivity
        dataModel: GroupDataModel {
            sortingKeys: [ "stamp" ]
            grouping: ItemGrouping.ByFullValue
            sortedAscending: false
        }
       
        listItemComponents: [
            ListItemComponent {
                type: "header"
                CustomListItem {
                    horizontalAlignment: HorizontalAlignment.Fill
                    CustomProgressDay {
                        horizontalAlignment: HorizontalAlignment.Fill
                        edate: ListItemData
                    }
                }
            },
            ListItemComponent {
                type: "item"
                CustomProgressActivity {
                    commenttext: ListItemData.summary
                    usertext: ListItemData.target
                    commenttime: ListItemData['updated_at']
                }
            }
        ]
    
    }    

}
}
