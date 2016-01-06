import bb.cascades 1.4
import bb.system 1.2
import bb.device 1.4
import "js/moment.js" as Moment
import 'views'
TabbedPane {
    property variant louisa: myStyle.style
    property variant discotech: discoexpand.style
    property variant log_accounts: []
    property variant current_user
    property variant activeaccount
    property variant projectslist
    property variant activeproject
    property variant touchedItem
    property variant people
    property variant activeitem
    id: tabholder
    Menu.definition: [
        MenuDefinition {
            actions: [
//                ActionItem {
//                    title: qsTr("About Us")
//                    imageSource: "asset:///images/BBicons/ic_info.png"
//                    onTriggered: {
//                        navigationpane.push(team_info.createObject())
//                    }
//                },
                ActionItem {
                    title: qsTr("Logout")
                    imageSource: "asset:///images/BBicons/logout.png"
                    onTriggered: {
                        logoutin.show()
                    }
                },
                ActionItem {
                    title: qsTr("Review")
                    imageSource: "asset:///images/BBicons/ic_compose.png"
                    attachedObjects: [
                        Invocation {
                            id: invoke
                            query: InvokeQuery {
                                invokeTargetId: "sys.appworld"
                                uri: "appworld://content/59950689"
                            }
                        }
                    ]
                    onTriggered: {
                        invoke.trigger("bb.action.OPEN")
                    }
                },
                ActionItem {
                    title: qsTr("Help")
                    imageSource: "asset:///images/BBicons/ic_help.png"
                    onTriggered: {
                        help.trigger("bb.action.OPEN")
                    }
                    attachedObjects: [
                        Invocation {
                            id: help
                            query: InvokeQuery {
                                invokeTargetId: "sys.browser"
                                uri: "https://ahamtech.in/kritus/help"
                            }
                        }
                    ]
                }

            ]
        }
    ]
    onCreationCompleted: {
        Qt.louisa = louisa
        getAuthorization()
        activitylist.dataModel.clear()
        activitylist.dataModel.insert({
                "type": "loading"
            })
        Qt.getProjects = getProjects
        Qt.archivedProjects = archivedProjects
        Qt.touchedItem = touchedItem
        Qt.callDeleteDialog = callDeleteDialog
        Qt.callCustomDialog = callCustomDialog
        Qt.onActivityTriggred = onActivityTriggred
        Qt.getprojectname = getprojectname
        Qt.convertDate = convertDate
    }
    onActiveitemChanged: {
        console.log(JSON.stringify(activeitem))
    }
    attachedObjects: [
        TextStyleDefinition {
            id: myStyle
            rules: [
                FontFaceRule {
                    source: "asset:///items/fonts/LouisaCP.otf"
                    fontFamily: "Louisa"
                }
            ]
            fontFamily: "Louisa, sans-serif"
        },
        TextStyleDefinition {
            id: discoexpand
            rules: [
                FontFaceRule {
                    source: "asset:///items/fonts/discotechiaexpand.ttf"
                    fontFamily: "discotech"
                }
            ]
            fontFamily: "discotech"
        },
        DeviceInfo {
            id: deviceinfo

        },
        ComponentDefinition {
            id: todolist_page
            source: "asset:///ToDoList.qml"
        },
        ComponentDefinition {
            id: documentsPage
            source: "asset:///items/ProgressDocuments.qml"
        },
        ComponentDefinition {
            id: todolistPage
            source: "asset:///items/ProgressTodolist.qml"
        },
        ComponentDefinition {
            id: calenderPage
            source: "asset:///items/ProgressCalenderEvents.qml"
        },
        ComponentDefinition {
            id: messagePage
            source: "asset:///items/ProgressMessages.qml"
        },
        ComponentDefinition {
            id: attachmentPage
            source: "asset:///items/ProgressAttachment.qml"
        },
        ComponentDefinition {
            id: accessPage
            source: "asset:///items/ProgressAccess.qml"
        },
        ComponentDefinition {
            id: todoPage
            source: "asset:///items/ProgressTodo.qml"
        },
        ComponentDefinition {
            id: forwardPage
            source: "asset:///items/ProgressForward.qml"
        },
        SystemDialog {
            confirmButton.label: qsTr("Delete List")
            id: deleteitem
            title: qsTr("Delete Project")
            body: qsTr("Delete Project Permanently ?")
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    deleteProject(Qt.touchedItem.url)
                } else {
                    touchedItem = null
                }
            }
        },
        SystemDialog {
            id: logoutin
            title: qsTr("Delete Account")
            body: qsTr("This will shutdown the application")
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    logout()
                }
            }
        }

    ]
    onActiveaccountChanged: {
        accounts.description = activeaccount.name
        getProjects()
        events()
        projects.enabled = true
        activity.enabled = true
        getPeople()
    }

    function onActivityTriggred(data) {

        activeitem = data.eventable.url
        console.log(JSON.stringify(activeitem))
        switch (data.eventable.type) {
            case "Person":
            case "Project":
                {
                    if (data.action.indexOf("archived") == 0) {
                        console.log("archive project can't be viewed")
                        break
                    } else {
                        for (var i = 0; i < projectslist.length; i ++) {
                            console.log(data.eventable.id, projectslist[i].id)
                            if (projectslist[i].id == data.eventable.id) {
                                activeproject = projectslist[i]
                            }
                        }
                        tabholder.activeTab = projects
                        project_navigation.push(project_view.createObject())
                        break
                    }
                }
            case "Message":
                {
                    activity_navigation.push(messagePage.createObject())
                    break
                }
            case "CalendarEvent":
                {
                    activity_navigation.push(calenderPage.createObject())
                    break
                }
            case "Todo":
                {
                    activity_navigation.push(todoPage.createObject())
                    break
                }
            case "Todolist":
                {
                    activity_navigation.push(todolistPage.createObject())
                    break
                }
            case "Upload":
                {
                    activity_navigation.push(attachmentPage.createObject())
                    break
                }
            case "Forward":
                {
                    activity_navigation.push(forwardPage.createObject())
                    break
                }
            case "Document":
                {
                    activity_navigation.push(documentsPage.createObject())
                    break
                }

        }
    }
    function onUpdateAccepted(name, description) {
        console.log("the chnaged project name", name);
    }
    function callDeleteDialog() {
        deleteitem.show()
    }

    function callCustomDialog() {
        custom_dialog.open()
    }
    function renderAccounts(data) {
        log_accounts = new Array()
        current_user = null
        current_user = data.identity
        accounts_list.dataModel.clear()
        for (var i = 0; i < data["accounts"].length; i ++) {
            if (data["accounts"][i].product == "bcx") {
                accounts_list.dataModel.append(data["accounts"][i])
            }
        }
    }

    function renderProjects() {
        projects.description = projectslist.length + " Projects"
        projects_list.dataModel.clear()
        projects_list.dataModel.append(projectslist)
    }
    sidebarState: SidebarState.VisibleFull

    Tab {
        id: accounts
        title: "Accounts"
        imageSource: "asset:///images/BBicons/ic_add_to_contacts.png"
        NavigationPane {
            id: accounts_navigation
            Page {
                titleBar: TitleBar {
                    kind: TitleBarKind.FreeForm
                    kindProperties: FreeFormTitleBarKindProperties {
                        content: Container {
                            leftPadding: 20
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            ImageView {

                                maxHeight: 70
                                maxWidth: 70
                                horizontalAlignment: HorizontalAlignment.Center
                                verticalAlignment: VerticalAlignment.Center
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: -1
                                }
                                imageSource: "asset:///icon.png"
                            }
                            Label {

                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                verticalAlignment: VerticalAlignment.Center

                                text: "Kritus"
                                textStyle.fontSize: FontSize.Large

                            }
                        }
                    }
                }

                actionBarVisibility: ChromeVisibility.Default
                actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
                Container {
                    background: Color.create("#fbf8f5")
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        layout: DockLayout {

                        }
                        Container {
                            background: Color.Black
                            opacity: .2
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Center
                            minHeight: 60
                            maxHeight: 60

                        }
                        Container {
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            Label {
                                horizontalAlignment: HorizontalAlignment.Center
                                verticalAlignment: VerticalAlignment.Center

                                text: "Choose  an account"
                                implicitLayoutAnimationsEnabled: true
                            }
                        }
                    }
                    
                    Container {
                        topPadding: ui.du(1.2)
                        horizontalAlignment: HorizontalAlignment.Fill
                       attachedObjects: [
                           LayoutUpdateHandler {
                               id: listhandler
                               onLayoutFrameChanged: {
                                   console.log(layoutFrame.width)
                               }
                           }
                       ]
                        ListView {
                            id: accounts_list
                            dataModel: ArrayDataModel {

                            }
                            leadingVisual: 
                                    PullToRefresh {
                                        preferredWidth: listhandler.layoutFrame.width
                                        id: pullRefresh
                                        onRefreshTriggered: {
                                            console.log("Refresh Triggered")
                                            getAuthorization()
                                        }
                                       
                                    }

                            listItemComponents: [
                                

                                ListItemComponent {
                                    type: ""
                                    CustomAccountList {
                                        title: ListItemData.name

                                    }
                                }
                            ]
                            onTriggered: {
                                clearSelection()
                                select(indexPath)
                                activeaccount = dataModel.data(indexPath)
                                if (selected()) {
                                    tabholder.sidebarState = SidebarState.VisibleFull
                                } else {
                                    tabholder.sidebarState = SidebarState.Hidden

                                }
                            }
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Fill
                        }

                    }
                }
            }
        }
    }
    Tab {
        id: activity
        title: "Progress"
        imageSource: "asset:///images/new/progressiconmain.png"
        enabled: false
        NavigationPane {
            id: activity_navigation
            onPopTransitionEnded: {
                page.destroy()
            }
            Page {
                objectName: "activity"
                titleBar: TitleBar {
                    title: "Daily Progress"
                }
                actionBarVisibility: ChromeVisibility.Compact
                actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll

                Container {
                    background: Color.create("#fbf8f5")
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        attachedObjects: LayoutUpdateHandler {
                            id: handler
                        }
                        Container {
                            id: activityloading
                            horizontalAlignment: HorizontalAlignment.Fill
                            layout: DockLayout {

                            }
                            bottomPadding: ui.du(2.0)
                            Container {
                                background: Color.Black
                                opacity: .2
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                                minHeight: 60
                                maxHeight: 60

                            }
                            Container {
                                horizontalAlignment: HorizontalAlignment.Center
                                verticalAlignment: VerticalAlignment.Center
                                Label {
                                    horizontalAlignment: HorizontalAlignment.Center
                                    verticalAlignment: VerticalAlignment.Center

                                    text: "Loading Data"
                                    implicitLayoutAnimationsEnabled: true
                                }
                            }
                        }
                        ListView {
                            topMargin: ui.du(2)
                            id: activitylist
                            dataModel: GroupDataModel {
                                grouping: ItemGrouping.ByFullValue
                                sortingKeys: [ "hea", "year" ]
                                sortedAscending: false
                            }
                            //                            function itemType(data,indexPath){
                            //                                console.log(JSON.stringify(data,indexPath))
                            //                                if(indexPath[0]==0 && indexPath[1]==0){
                            //                                    console.log("listitemdata"+JSON.stringify(data))
                            //                                    return "tit"
                            //                                }
                            //
                            //                                else if(indexPath.length>1){
                            //                                    return "item"
                            //                                }
                            //                                else if(indexPath[0]==1) return "header"
                            //
                            //                            }
                            onTriggered: {
                                if (indexPath.length > 1)
                                    Qt.onActivityTriggred(dataModel.data(indexPath))
                            }
                            leadingVisual: PullToRefresh {
                                preferredWidth: listhandler.layoutFrame.width

                                onRefreshTriggered: {
                                    events()
                                }
                            }
                            listItemComponents: [
                                //                                ListItemComponent {
                                //                                    type: "loading"
                                //                                    CustomListItem {
                                //                                        Container {
                                //                                            horizontalAlignment: HorizontalAlignment.Center
                                //                                            Label {
                                //
                                //                                                horizontalAlignment: HorizontalAlignment.Center
                                //                                                text: qsTr("Loading")
                                //                                                multiline: true
                                //                                                textStyle.fontSize: FontSize.PointValue
                                //                                                textStyle.fontSizeValue: 15
                                //                                                textStyle.fontWeight: FontWeight.W300
                                //                                                verticalAlignment: VerticalAlignment.Center
                                //                                                textFit.mode: LabelTextFitMode.Standard
                                //
                                //                                            }
                                //                                        }
                                //                                    }
                                //                                },
                                //                                ListItemComponent {
                                //                                    type: "tit"
                                //                                    CustomListItem {
                                //                                        Container {
                                //                                            leftPadding: ui.du(1.0)
                                //                                            rightPadding: ui.du(1.0)
                                //                                            horizontalAlignment: HorizontalAlignment.Center
                                //                                            Label {
                                //                                                horizontalAlignment: HorizontalAlignment.Center
                                //                                                text: qsTr("Here's what's been happening in your projects.")
                                //                                                multiline: true
                                //                                                textStyle.fontSize: FontSize.PointValue
                                //                                                textStyle.fontSizeValue: 15
                                //                                                textStyle.fontWeight: FontWeight.W300
                                //                                                verticalAlignment: VerticalAlignment.Center
                                //                                                textFit.mode: LabelTextFitMode.Standard
                                //
                                //                                            }
                                //                                        }
                                //                                    }
                                //                                },
                                ListItemComponent {
                                    type: "header"
                                    CustomListItem {
                                        horizontalAlignment: HorizontalAlignment.Fill
                                        CustomProgressDay {
                                            leftPadding: ui.du(1.0)
                                            rightPadding: ui.du(1.0)
                                            horizontalAlignment: HorizontalAlignment.Fill
                                            edate: Qt.convertDate(ListItemData)
                                        }
                                    }
                                },
                                ListItemComponent {
                                    type: "item"
                                    CustomProgressActivity {
                                        leftPadding: ui.du(1.0)
                                        rightPadding: ui.du(1.0)
                                        commenttext: ListItemData.summary
                                        usertext: ListItemData.creator.name
                                        commenttime: Moment.moment(ListItemData['updated_at']).format("lll")
                                        project: Qt.getprojectname(ListItemData)
                                        onCreationCompleted: {
                                            console.log(ListItemData)
                                        }

                                    }
                                }
                            ]
                        }
                    }
                }

            }
        }
    }

    Tab {
        enabled: false
        id: projects
        title: "Projects"
        imageSource: "asset:///images/new/projectsicon.png"

        NavigationPane {
            onPopTransitionEnded: {
                page.destroy()
            }
            attachedObjects: [
                ComponentDefinition {
                    id: archivedProgectPage
                    source: "asset:///views/ArchivedProjects.qml"
                },
                ComponentDefinition {
                    id: createProjectPage
                    source: "asset:///new/NewProject.qml"
                },
                ComponentDefinition {
                    id: project_view
                    source: "asset:///views/ProjectView.qml"
                }
            ]
            id: project_navigation
            Page {
                actions: [
                    ActionItem {
                        title: "Create Project"
                        ActionBar.placement: ActionBarPlacement.Signature

                        imageSource: "asset:///images/BBicons/ic_add.png"
                        onTriggered: {
                            project_navigation.push(createProjectPage.createObject())

                        }
                    },
                    ActionItem {
                        title: "Archived Projects"
                        imageSource: "asset:///images/BBicons/ic_doctype_zip.png"
                        onTriggered: {
                            project_navigation.push(archivedProgectPage.createObject())
                        }
                    }
                ]
                titleBar: TitleBar {
                    title: "Projects"

                }
                actionBarVisibility: ChromeVisibility.Default
                actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
                actionBarFollowKeyboardPolicy: ActionBarFollowKeyboardPolicy.Default
                resizeBehavior: PageResizeBehavior.None
                Container {
                    background: Color.create("#fbf8f5")
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    Container {
                        background: Color.create("#fbf8f5")
                        horizontalAlignment: HorizontalAlignment.Fill
                        attachedObjects: LayoutUpdateHandler {
                            id: listHandler
                        }
                        ListView {
                            id: projects_list
                            dataModel: ArrayDataModel {

                            }
                            leadingVisual: PullToRefresh {
                                preferredWidth: listHandler.layoutFrame.width

                                onRefreshTriggered: {
                                    getProjects()
                                }
                            }
                            onTriggered: {
                                activeproject = dataModel.data(indexPath)
                                project_navigation.push(project_view.createObject())
                            }
                            listItemComponents: [
                                ListItemComponent {
                                    type: ""
                                    CustomProjectList {
                                        contextActions: [
                                            ActionSet {
                                                actions: [
                                                    ActionItem {
                                                        title: "Archive"
                                                        imageSource: "asset:///images/BBicons/ic_doctype_zip.png"
                                                        onTriggered: {
                                                            Qt.archivedProjects(ListItemData.url)
                                                        }
                                                    },
                                                    //                                                    ActionItem {
                                                    //                                                        title: "Update"
                                                    //                                                        imageSource: "asset:///images/BBicons/ic_reload.png"
                                                    //
                                                    //                                                        onTriggered: {
                                                    //                                                            Qt.touchedItem = ListItemData
                                                    //                                                            Qt.callCustomDialog()
                                                    //                                                        }
                                                    //                                                    },
                                                    ActionItem {
                                                        title: "Delete"
                                                        imageSource: "asset:///images/BBicons/ic_delete.png"

                                                        onTriggered: {
                                                            Qt.touchedItem = ListItemData
                                                            Qt.callDeleteDialog()
                                                        }
                                                    }
                                                ]
                                            }
                                        ]
                                        des: ListItemData.description
                                        title: ListItemData.name
                                        fav: ListItemData.starred
                                        update: Moment.moment(ListItemData["updated_at"]).format("lll")
                                    }
                                }
                            ]
                        }
                    }

                }
            }
        }
    }

    function getAuthorization() {
        var doc = new XMLHttpRequest();
        var url = "https://launchpad.37signals.com/authorization.json"
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    var data = JSON.parse(doc.responseText)
                    renderAccounts(data);
                } else {
                    finalResp(doc)
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
    function executeUrl(in_url, in_data, url_type, status, callback) {
        console.log("url execution started")
        var doc = new XMLHttpRequest();
        var info = JSON.stringify(in_data)
        var url = endpoint + in_url

        if (in_data != "") {
            for (var key in in_data) {
                url += "?" + key + "=" + in_data[key]
                if (in_data.length > 1) {
                    console.log("parameters greater than 1")
                    url += "&"
                    continue
                } else break

            }
        }
        console.log("this is url", url)
        console.log("this is data", JSON.stringify(in_data))
        console.log("this is status", status)
        console.log("url type", url_type)
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                console.log("this is the doc status", doc.status)
                if (doc.status == status) {
                    var data = []
                    if (doc.responseText) {
                        data = JSON.parse(doc.responseText)
                        pushData(data);
                    }

                    callback()
                    console.log("url execution end")
                    console.log("tasks data", data)
                } else {
                    console.log("status not matched", doc.status)
                }
            }
        }
        doc.open(url_type, url);
        doc.setRequestHeader("X-Access-Token", token);
        doc.setRequestHeader("X-Client-ID", client);
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.setRequestHeader("Content-Type", "application/json");
        doc.send()
    }
    function getProjects() {
        var doc = new XMLHttpRequest();
        var url = activeaccount.href + "/projects.json"
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    console.log(doc.responseText)
                    var data = JSON.parse(doc.responseText)
                    projectslist = data
                    renderProjects()
                } else {

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
    function archivedProjects(url) {
        console.log(url)
        var param = {
            "archived": true
        }
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    getProjects()
                } else {
                    console.log(doc.status + doc.responseText)
                }
            }
        }
        doc.open("PUT", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send(JSON.stringify(param));
    }
    function deleteProject(url) {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 204) {
                    getProjects()
                } else {

                }
            }
        }
        doc.open("DELETE", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send();
    }
    function events() {
        var doc = new XMLHttpRequest();
        var url = activeaccount.href + "/events.json"
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    activityloading.visible = false
                    var events = JSON.parse(doc.responseText)
                    events.reverse()
                    activitylist.dataModel.clear()
                    //                    var f_data = {
                    //                        "type": "tit"
                    //                    }

                    for (var i = 0; i < events.length; i ++) {
                        var d_data = Moment.moment(events[i]["updated_at"]).format("ll")
                        //                        var t = d_data.split("-")
                        //                        events[i]["stamp"] = d_data
                        //                        events[i]["year"] = t[0]
                        //                        events[i]["month"] = t[1]
                        //                        events[i]["day"] = t[2]
                        events[i]["hea"] = Moment.moment(events[i]["updated_at"]).format("L")
                    }
                    //                    events.unshift(f_data)
                    activitylist.dataModel.insertList(events)
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
    function getPeople() {
        var doc = new XMLHttpRequest();
        var url = activeaccount.href + "/people.json"
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    people = JSON.parse(doc.responseText)
                    for (var i = 0; i < people.length; i ++) {
                        console.log(JSON.stringify(people[i]))
                    }
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
    function getprojectname(data) {
        for (var i = 0; i < projectslist.length; i ++) {
            var projectendid = projectslist[i]["app_url"].split("/")
            var projectendad = data.url.split("/")[7]
            var projectenddd = projectendad.split(".")
            if (projectenddd[0] == projectendid[5]) {
                return projectslist[i].name
            }
        }
    }
    function finalResp(data) {
        if (data.status == 401) {
            app.logout()
        }
    }
    function logout() {
        app.logout()
        Application.requestExit()
    }
    function convertDate(data) {
        return Moment.moment(data).format('ll')

    }
}
