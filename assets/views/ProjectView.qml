import bb.cascades 1.4
import "../js/moment.js" as Moment
import bb.cascades.pickers 1.0
import "projecttabs"

Page {
    property variant projectinfo
    property variant globalvar
    onCreationCompleted: {
        Qt.onActivityTriggredApp = onActivityTriggredApp
        Qt.onEventTriggredApp = onEventTriggredApp
        title.text = activeproject.name
        projectInfo()
        events()
    }

    onGlobalvarChanged: {
        items(globalvar)
    }
    function onOptionValueChnaged(value) {
        globalvar = value
    }
    function onActivityTriggredApp(data) {
        activeitem = data.eventable.url
        console.log(JSON.stringify(data.eventable))
        if (data.action.indexOf('deleted') == 0) {

        } else {
            switch (data.eventable.type) {
                case "Message":
                    project_navigation.push(messagePage.createObject())
                    break
                case "CalendarEvent":
                    project_navigation.push(calenderPage.createObject())
                    break
                case "Todo":
                    project_navigation.push(todoPage.createObject())
                    break
                case "Todolist":
                    project_navigation.push(todolistPage.createObject())
                    break
                case "Upload":
                    project_navigation.push(attachmentPage.createObject())
                    break
                case "Forward":
                    project_navigation.push(forwardPage.createObject())
                    break
                case "Document":
                    project_navigation.push(documentsPage.createObject())
                    break

            }
        }
    }
    function onEventTriggredApp(data) {
        var switc = ""
        if (globalvar == "topics") {
            switc = data.topicable.type
            activeitem = data.topicable.url
        } else {
            switc = globalvar
            activeitem = data.url
        }
        console.log(switc)
        switch (switc) {
            case "calendar_events":
                project_navigation.push(calenderPage.createObject())
                break
            case "todolists":
                project_navigation.push(todolistPage.createObject())
                break
            case "attachments":
                project_navigation.push(attachmentPage.createObject())
                break
            case "documents":
                project_navigation.push(documentsPage.createObject())
                break
            case "Message":
                project_navigation.push(messagePage.createObject())
                break
            case "CalendarEvent":
                project_navigation.push(calenderPage.createObject())
                break
            case "Todo":
                project_navigation.push(todoPage.createObject())
                break
            case "Todolist":
                project_navigation.push(todolistPage.createObject())
                break
            case "Upload":
                project_navigation.push(attachmentPage.createObject())
                break
            case "Forward":
                project_navigation.push(forwardPage.createObject())
                break
            case "Document":
                project_navigation.push(documentsPage.createObject())
                break
        }
    }
    titleBar: TitleBar {
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftPadding: 10
                rightPadding: 10
                Label {
                    id: title
                    text: "Project name"
                    textStyle.base: Qt.Louisa
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                }
                ToggleButton {
                    id: toggleExpanded
                    opacity: 0.7
                    verticalAlignment: VerticalAlignment.Center
                }
            }
            expandableArea {
                content: ScrollView {

                    RadioGroup {

                        Option {
                            value: "events"
                            text: qsTr("Latest project updates")
                            selected: true
                        }
                        Option {
                            value: "todolists"
                            text: qsTr("To-dos lists")
                            imageSource: "asset:///images/BBicons/ic_doneblack.png"
                        }
                        Option {
                            value: "topics"
                            text: qsTr("Discussions")
                            imageSource: "asset:///images/BBicons/ic_bbm.png"
                        }
                        Option {
                            value: "documents"
                            text: qsTr("Text documents")
                            imageSource: "asset:///images/BBicons/ic_doctype_generic.png"

                        }
                        Option {
                            value: "attachments"
                            text: qsTr("Files")
                            imageSource: "asset:///images/BBicons/ic_attach.png"

                        }
                        Option {
                            value: "calendar_events"
                            text: qsTr("Upcoming events")
                            imageSource: "asset:///images/BBicons/ic_duedate.png"

                        }
                        onSelectedValueChanged: {
                            toggleExpanded.checked = false
                            title.text = selectedOption.text
                            if (selectedValue == "events") {
                                projectactivity.visible = true
                                itemslist.visible = false
                            } else {
                                projectactivity.visible = false
                                itemslist.visible = true
                                onOptionValueChnaged(selectedValue)
                            }

                        }
                    }
                }
                indicatorVisibility: TitleBarExpandableAreaIndicatorVisibility.Hidden
                expanded: toggleExpanded.checked
                onExpandedChanged: {
                    toggleExpanded.checked = expanded

                }
            }
        }
    }
    attachedObjects: [
        FilePicker {
            id: filePicker
            type: FileType.Picture
            title: "Select Picture"
            directories: [ "/accounts/1000/shared/misc" ]
            onFileSelected: {
                console.log("FileSelected signal received : " + selectedFiles);
            }
        },
        ComponentDefinition {
            id: postmessage
            source: "asset:///views/projectnewactions/postmessage.qml"
        },
        ComponentDefinition {
            id: todo_page
            source: "asset:///views/projectnewactions/addtodo.qml"
        },
        ComponentDefinition {
            id: invite_people_page
            source: "asset:///views/projectnewactions/invitepeople.qml"
        },
        ComponentDefinition {
            id: new_event_page
            source: "asset:///views/projectnewactions/newevent.qml"
        },
        ComponentDefinition {
            id: new_document_page
            source: "asset:///views/projectnewactions/newdocument.qml"
        }
    ]
    Container {
        topMargin: ui.du(2)
        horizontalAlignment: HorizontalAlignment.Fill
        attachedObjects: LayoutUpdateHandler {
            id: handler
        }
        ListView {
            visible: false
            id: itemslist
            dataModel: ArrayDataModel {

            }
            function itemType(data, indexPath) {
                return data.type
            }
            leadingVisual: PullToRefresh {
                preferredWidth: handler.layoutFrame.width
                touchActive: projects_list.isTouched
                onRefreshTriggered: {
                    items(globalvar)
                }
            }
            onTriggered: {
                Qt.onEventTriggredApp(dataModel.data(indexPath))
            }
            listItemComponents: [
                ListItemComponent {
                    type: "topics"
                    CustomDiscussionItem {
                        user: ListItemData["last_updater"].name
                        time: Moment.moment(ListItemData['updated_at']).format("lll")
                        message: ListItemData.title
                        description: ListItemData.excerpt

                    }

                },
                ListItemComponent {
                    type: "todolists"
                    CustomListItem {
                        CustomTodoList {
                            title: ListItemData.name
                            description: ListItemData.description
                            complete: ListItemData["completed_count"]
                            remain: ListItemData["remaining_count"]
                            total: ListItemData["completed_count"] + ListItemData["remaining_count"]
                        }
                    }
                },
                ListItemComponent {
                    type: "attachments"
                    CustomListItem {
                        CustomFilesItem {
                            description: ListItemData.attachable.type
                            fileName: ListItemData.name
                            user: ListItemData.creator.name
                            imageType: ListItemData["content_type"]
                            imageSize: Math.round((ListItemData["byte_size"] / 1024 / 1024) * 100) / 100 + "mb"
                            dateTime: Moment.moment(ListItemData['updated_at']).format("lll")
                        }
                    }
                },
                ListItemComponent {
                    type: "calendar_events"
                    CustomListItem {
                        CustomEventsList {
                            eventName: ListItemData.summary

                            timetext: Moment.moment(ListItemData["starts_at"]).format("dddd")
                            monthtext: Moment.moment(ListItemData["starts_at"]).format("D")
                            daytext: Moment.moment(ListItemData["starts_at"]).format("MMM")

                        }
                    }
                },
                ListItemComponent {
                    type: "documents"
                    CustomListItem {

                        CustomDocumentList {
                            horizontalAlignment: HorizontalAlignment.Fill
                            dtime: Moment.moment(ListItemData['updated_at']).format("lll")
                            title: ListItemData.title
                        }
                    }
                }

            ]
            horizontalAlignment: HorizontalAlignment.Fill
        }
        ListView {
            id: projectactivity
            dataModel: GroupDataModel {
                sortingKeys: [ "stamp" ]
                grouping: ItemGrouping.ByFullValue
                sortedAscending: false
            }
            leadingVisual: PullToRefresh {
                preferredWidth: handler.layoutFrame.width
                touchActive: projects_list.isTouched
                onRefreshTriggered: {
                    events()
                }
            }
            onTriggered: {
                if (indexPath.length > 1)
                    Qt.onActivityTriggredApp(dataModel.data(indexPath))
            }
            listItemComponents: [
                ListItemComponent {
                    type: "header"
                    CustomListItem {
                        dividerVisible: false
                        horizontalAlignment: HorizontalAlignment.Fill
                        CustomProjectDay {
                            horizontalAlignment: HorizontalAlignment.Fill
                            edate: Qt.convertDate(ListItemData)
                        }
                    }
                },
                ListItemComponent {
                    type: "item"
                    CustomProjectActivity {
                        commenttext: ListItemData.summary
                        usertext: ListItemData.creator.name
                        commenttime: Moment.moment(ListItemData['updated_at']).format("lll")
                    }
                }
            ]

        }

    }
    actions: [
        ActionItem {
            title: qsTr("Post a message")
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///images/BBicons/ic_bbm.png"
            onTriggered: {
                project_navigation.push(postmessage.createObject())
            }
            shortcuts: [
                SystemShortcut {
                    type: SystemShortcuts.CreateNew
                }
            ]
        },
        ActionItem {
            title: qsTr("Make a to-do list")
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/BBicons/ic_done.png"
            onTriggered: {
                project_navigation.push(todo_page.createObject())
            }

        },
        ActionItem {
            title: qsTr("Write a document")
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/BBicons/ic_entry.png"
            onTriggered: {
                project_navigation.push(new_document_page.createObject())
            }
        },
        ActionItem {
            title: qsTr("Add an event")
            imageSource: "asset:///images/BBicons/ic_compose.png"
            onTriggered: {
                project_navigation.push(new_event_page.createObject())

            }
        },
        ActionItem {
            title: qsTr("Project members")
            imageSource: "asset:///images/BBicons/ic_contacts.png"
            onTriggered: {
            
            }
        }
    ]
    actionBarVisibility: ChromeVisibility.Default
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    resizeBehavior: PageResizeBehavior.Resize
    actionBarFollowKeyboardPolicy: ActionBarFollowKeyboardPolicy.Portrait
    function events() {
        var doc = new XMLHttpRequest();
        var url = activeproject['url'].replace('.json', "/events.json")
        console.log(url)
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    console.log(doc.responseText)
                    var events = JSON.parse(doc.responseText)
                    events.reverse()
                    projectactivity.dataModel.clear()
                    for (var i = 0; i < events.length; i ++) {
                        events[i].stamp = Moment.moment(events[i]["updated_at"]).format("L")
                    }
                    projectactivity.dataModel.insertList(events)
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
    function items(item) {
        var doc = new XMLHttpRequest();
        var url = activeproject['url'].replace('.json', "/" + item + ".json")
        console.log(url)
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    console.log(doc.responseText)
                    var events = JSON.parse(doc.responseText)

                    itemslist.dataModel.clear()
                    for (var i = 0; i < events.length; i ++) {
                        var stamp = Moment.moment(events[i]["updated_at"]).format("ll")
                        events[i].stamp = stamp
                        events[i].type = item
                        if (item == "attachments") {
                            events[i].url = events[i].attachable.url
                        }
                    }
                    itemslist.dataModel.append(events)
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
}
