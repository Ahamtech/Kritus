import bb.cascades 1.4
Container {
    property alias title: list_title.text
    property alias description: desc.text
    property alias remain: remaining.text
    property alias complete: completed.text
    property alias total: tot.text
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)

    topPadding: ui.du(1.0)
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        Container {
            topPadding: 5
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            Label {
                id: list_title
                // list title
                verticalAlignment: VerticalAlignment.Center
                text: "List Title List Title List Title List Title"
                textStyle.fontSize: FontSize.Medium
                textStyle.fontWeight: FontWeight.W500
                textStyle.base: Qt.Louisa

            }

        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Container {
                topPadding: 15
                ImageView {
                    imageSource: "asset:///images/new/hourglass.png"
                    preferredHeight: 30
                    preferredWidth: 30
                }
            }
            Container {
                verticalAlignment: VerticalAlignment.Center
                Label {
                    id: remaining
                    verticalAlignment: VerticalAlignment.Center
                    text: "100"
                }
            }

        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Container {
                topPadding: 10
                ImageView {
                    imageSource: "asset:///images/new/ic_done_blue.png"
                    preferredHeight: 30
                    preferredWidth: 30
                }
            }
            Container {
                verticalAlignment: VerticalAlignment.Center
                Label { //completed
                    id: completed
                    verticalAlignment: VerticalAlignment.Center
                    text: "100"
                }
            }

        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Container {
                topPadding: 10
                ImageView {
                    imageSource: "asset:///images/new/commentdot.png"
                    preferredHeight: 30
                    preferredWidth: 30
                }
            }
            Container {
                verticalAlignment: VerticalAlignment.Center
                Label { //remaing
                    id: tot
                    verticalAlignment: VerticalAlignment.Center
                    text: "100"
                }
            }

        }
    }
    Container {
        bottomPadding: ui.du(1.0)
        // description
        Label {
            id: desc
            text: "asdfghjkkjfsdfghjklllkjhgfaertkmnbvcxserhjnfhbvfg"
            textStyle.base: Qt.discotech

        }
    }
//    Container {
//        
//        background: Color.Gray
//        preferredHeight: 2
//        horizontalAlignment: HorizontalAlignment.Fill
//    }
}
