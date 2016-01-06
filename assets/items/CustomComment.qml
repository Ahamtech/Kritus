import bb.cascades 1.4

Container {
    property alias time: datetime.text
    property alias title: comment.text
    property alias user: username.text
    background: Color.create("#fbf8f5")
    horizontalAlignment: HorizontalAlignment.Fill

    implicitLayoutAnimationsEnabled: false
    //    Container {
    //        background: Color.Gray
    //        horizontalAlignment: HorizontalAlignment.Fill
    //        preferredHeight: 2
    //
    //    }

    Container {
        topPadding: ui.du(1)
        leftPadding: ui.du(1)
        bottomPadding: ui.du(1)
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        minHeight: 140

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            horizontalAlignment: HorizontalAlignment.Fill
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 0.5
                }
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Container {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 0.25
                    }
                    horizontalAlignment: HorizontalAlignment.Left
                    layout: AbsoluteLayout {

                    }
                    Container {
                        topPadding: 5
                        preferredHeight: 80
                        preferredWidth: 80
                        ImageView {
                            imageSource: "asset:///images/new/loginimage.png"
                        }
                    }
                    Container {
                        topPadding: 5
                        preferredHeight: 80
                        preferredWidth: 80

                        ImageView {
                            filterColor: Color.create("#fbf8f5")
                            imageSource: "asset:///images/new/pic.png"
                        }
                    }

                }
                Container {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 0.75
                    }
                    leftPadding: 8
                    verticalAlignment: VerticalAlignment.Center
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        id: username
                        text: "Name NAme asnmawesbjhdan kgafhjbn kgadhfjbn"
                        textStyle.fontSize: FontSize.Medium
                        textStyle.fontStyle: FontStyle.Default
                        textStyle.fontWeight: FontWeight.W500
                    }
                }
            }
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 0.5
                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Center
                Label {
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Center
                    id: datetime
                    text: "Date "
                    opacity: 0.7
                    //  textStyle.fontWeight: FontWeight.W500
                }
            }
        }
        Container {

            Label {
                multiline: true
                text: "Comment vComment CommentComment Comment Comment Comment Comment Comment Comment Comment"
                id: comment
            }
        }
    }
    /* Container {
     * topPadding: ui.du(1)
     * leftPadding: ui.du(1)
     * 
     * horizontalAlignment: HorizontalAlignment.Fill
     * verticalAlignment: VerticalAlignment.Fill
     * minHeight: 140
     * layout: DockLayout {
     * 
     * }
     * 
     * Container {
     * horizontalAlignment: HorizontalAlignment.Left
     * layout: AbsoluteLayout {
     * 
     * }
     * verticalAlignment: VerticalAlignment.Top
     * Container {
     * topPadding: 5
     * preferredHeight: 80
     * preferredWidth: 80
     * ImageView {
     * imageSource: "asset:///images/new/loginimage.png"
     * }
     * }
     * Container {
     * topPadding: 5
     * preferredHeight: 80
     * preferredWidth: 80
     * 
     * ImageView {
     * filterColor: Color.create("#fbf8f5")
     * imageSource: "asset:///images/new/pic.png"
     * }
     * }
     * 
     * }
     * Container {
     * leftPadding: 100
     * verticalAlignment: VerticalAlignment.Top
     * layout: StackLayout {
     * orientation: LayoutOrientation.LeftToRight
     * 
     * }
     * Container {
     * verticalAlignment: VerticalAlignment.Center
     * Label {
     * //id: username
     * text: "Name"
     * textStyle.fontSize: FontSize.Medium
     * textStyle.fontStyle: FontStyle.Default
     * textStyle.fontWeight: FontWeight.W500
     * }
     * }
     * Container {
     * horizontalAlignment: HorizontalAlignment.Right
     * verticalAlignment: VerticalAlignment.Center
     * Label {
     * // id: datetime
     * text: "Date"
     * //                    opacity: 0.7
     * textStyle.fontWeight: FontWeight.W500
     * }
     * }
     * 
     * }
     * Container {
     * verticalAlignment: VerticalAlignment.Bottom
     * horizontalAlignment: HorizontalAlignment.Left
     * Label {
     * multiline: true
     * text: "Comment vComment CommentComment Comment Comment Comment Comment Comment Comment Comment"
     * //  id: comment
     * }
     * }
     * 
     }*/
}
