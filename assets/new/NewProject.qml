import bb.cascades 1.4
import bb.system 1.2

Page {
    id: createproject
    titleBar: TitleBar {
        title: "Create New Project"
    }
    attachedObjects: [
        SystemToast {
            id: toast
        }
    ]
    Container {
        topPadding: 20
        leftPadding: 20
        rightPadding: 20
        ActivityIndicator {
            id: loader
            minHeight: 100
            horizontalAlignment: HorizontalAlignment.Center
            visible: false
        }
        TextArea {
            id: name
            
            hintText: "Project Name"
        }
        TextArea {
            preferredHeight: 300
            id: des
            hintText: "Project Descrption"
        
        }
    }actions: [
        ActionItem {
            title: "Create Project"
            ActionBar.placement: ActionBarPlacement.Signature
            imageSource: "asset:///images/BBicons/ic_save.png"
            onTriggered: {
                loader.running=true
                createProject()
            }
        }
        
    ]
    function createProject() {
        var doc = new XMLHttpRequest();
        var url = activeaccount.href + "/projects.json"
        var param = {
            "name" : name.text,
            "description" : des.text
        }
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 201) {
                    console.log(doc.responseText)
                    Qt.getProjects()
                    loader.running=false
                    toast.body="Project Created"
                    toast.show()
                    createproject.parent.pop()
                } else {
                    toast.body="Project Creation fail.."
                    toast.show()
                    console.log(doc.status + doc.responseText)
                }
            }
        }
        doc.open("post", url);
        doc.setRequestHeader("Authorization", "Bearer " + app.getToken());
        doc.setRequestHeader("Content-Type", "application/json");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send(JSON.stringify(param));
    }
}
