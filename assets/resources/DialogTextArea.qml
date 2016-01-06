import bb.cascades 1.4
import bb.system 1.2

Dialog {
    id: addpost
    Container {
        background: Color.create("#fbf8f5")
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        Container {
            leftPadding: ui.du(2)
            rightPadding: ui.du(2)
            topPadding: ui.du(2)
            bottomPadding: ui.du(2)
            horizontalAlignment: HorizontalAlignment.Center
            Label {
                horizontalAlignment: HorizontalAlignment.Center
                text: qsTr("Add comment ")
                textStyle.fontSize: FontSize.Large
                textStyle.fontWeight: FontWeight.Bold

            }
            TextArea {
                id: commentarea
                preferredHeight: 300
                hintText: qsTr("Add a comment")
                input.submitKey: SubmitKey.Done
                onTextChanging: {

                    postbutton.enabled = text.length > 0

                }

            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Button {
                    text: qsTr("Cancel")
                    onClicked: {
                        addpost.close()
                    }
                }
                Button {
                    enabled: false
                    id: postbutton
                    horizontalAlignment: HorizontalAlignment.Center
                    text: qsTr("Post")
                    onClicked: {
                        if (commentarea.text.length > 0) {
                            postcomm.show()

                        }
                    }
                }

            }

        }
    }
    attachedObjects: [
        SystemToast {
            id: postcomm
            body: qsTr("Posting comment...")
        }
    ]
}