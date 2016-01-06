import bb.cascades 1.4
import bb.system 1.2
//import "../js/moment.js" as Moment

Page {
    titleBar: TitleBar {
        title: qsTr("Add a new event")
    }
    attachedObjects: [
        SystemToast {
            id: toast
        }
    ]
   
    Container {
        rightPadding: ui.du(2)
        leftPadding: ui.du(2)
        topPadding: ui.du(2)
        ActivityIndicator {
            preferredHeight: 100
            id: eventloader
           
            horizontalAlignment: HorizontalAlignment.Center
            
        }
        Label {
            text: qsTr("Event title :")
            textStyle.fontSize: FontSize.Medium
            textStyle.fontWeight: FontWeight.Bold
        }
        TextField {
            hintText: qsTr("Name the event...")
            id: title
            onTextChanging: {
                text.length>0?saveaction.enabled=true :saveaction.enabled=false
            }
        }
        Label {
            text: qsTr("Event description :")
            textStyle.fontSize: FontSize.Medium
            textStyle.fontWeight: FontWeight.Bold
        }
        TextArea {
            hintText: qsTr("Add an optional note...")
            autoSize.maxLineCount: 4
            id: des
        }

        DateTimePicker {
            id: start
            title: qsTr("Starts :")
            mode: DateTimePickerMode.Date
        }
        DateTimePicker {
            id: end
            title: qsTr("Ends :")
            mode: DateTimePickerMode.Date
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            Container {
                verticalAlignment: VerticalAlignment.Center
                CheckBox {
                    id: reminder
                    checked: false
                    onCheckedChanged: {
                        if(checked){}
                        else{}
                    }
                }
            }
            Container {
            leftMargin: ui.du(2)
                DateTimePicker {
                    id: remind
                    title: qsTr("Reminding at")
                    mode: DateTimePickerMode.DateTime
                }
            }
        }
    }
    actions: [
        ActionItem {
            id: saveaction
            enabled: false
            title: qsTr("Save")
            imageSource: "asset:///images/BBicons/ic_done.png"
            ActionBar.placement: ActionBarPlacement.Signature
            onTriggered: {
                eventloader.running=true
                sendData()
            }
        }
    ]
    function sendData(){
        var doc = new XMLHttpRequest();
        var url = activeproject['url'].replace('.json', "/calendar_events.json") 
        var param  = { "summary": title.text , description :des.text,"all_day": true,"starts_at":start.value.toISOString(), "ends_at": end.value.toISOString()}
        if(reminder.checked){
            param["remind_at"] = remind.value.toISOString()
        }
        console.log(JSON.stringify(param))
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 201) {
                    eventloader.running=true
                    toast.body="Event Created Successfully"
                    toast.show()
                    project_navigation.pop()
                } else {
                    toast.body="Error in creation try again"
                    toast.show()
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
}
