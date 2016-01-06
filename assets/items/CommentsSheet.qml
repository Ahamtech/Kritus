import bb.cascades 1.4

Sheet {
   id: mysheet
    Page {
        
        titleBar: TitleBar {
            title: "Comment"
            dismissAction: ActionItem {
                title: "close"
                onTriggered: {
                    mysheet.close()
                }
            }
            acceptAction: ActionItem {
                title: "Comment"
                onTriggered: {
                    comment(commentid.text);
                }
            }
        }
        Container {
            background: Color.create("#fefef0")
            leftPadding: ui.du(2.0)

            rightPadding: ui.du(2.0)
            bottomPadding: ui.du(2.0)
            topPadding: ui.du(2.0)
            Container {
                TextArea {
                    id: commentid
                    minHeight: ui.du(30)
                    autoSize.maxLineCount: -1
                    hintText: "enter comment"
                    
                }
            }
        }
        
    }
}