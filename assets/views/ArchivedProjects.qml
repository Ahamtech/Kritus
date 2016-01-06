import bb.cascades 1.4

Page {
    onCreationCompleted: {
        getArchivedProjects()
        Qt.unArchivedProjects=unArchivedProjects
    }
    titleBar: TitleBar {
        title: "Archived Projects"
    }
    Container {
        ListView {
            id: archivedProjectsList
            onLeadingVisualChanged: {
                if(visible){
                    getArchivedProjects()
                }
            }
            leadingVisual: [
                
                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    layout: StackLayout {
                    
                }
                   Container {
                       ActivityIndicator {
                           horizontalAlignment: HorizontalAlignment.Center

                       running: true
                       }
                   }
                   Container {
                       Label {
                           horizontalAlignment: HorizontalAlignment.Center

                           text: "Projects Sync"
                       }
                   }
                }
            ]
            dataModel: ArrayDataModel {
                
            }
            listItemComponents: [
                ListItemComponent {
                   CustomProjectList {
                       contextActions: [
                           ActionSet {
                               actions: [
                                   ActionItem {
                                       title: "UnArchive"
                                       imageSource: "asset:///images/BBicons/ic_doctype_zip.png"
                                       onTriggered: {
                                           Qt.unArchivedProjects(ListItemData.url)
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
    function getArchivedProjects() {
        var doc = new XMLHttpRequest();
        var url = activeaccount.href + "/projects/archived.json"
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    console.log(doc.responseText)
                    var data = JSON.parse(doc.responseText)
                    archivedProjectsList.dataModel.clear()
                    archivedProjectsList.dataModel.append(data)
                    archivedProjectsList.leadingVisual.visible=false
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
    function unArchivedProjects(url) {
        console.log(url)
        var param = {
            "archived": false
        }
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    getArchivedProjects()
                    Qt.getProjects()
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
}
