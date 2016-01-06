import bb.cascades 1.4

Container {
    property alias title: name.text
    property alias des: desc.text
    property alias update: updatedat.text
    property alias fav: favi.visible

    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.create("#fbf8f5")
        leftPadding: ui.du(1)
        rightPadding: ui.du(1)
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            leftPadding: ui.du(3.0)
            rightPadding: ui.du(1.0)
            bottomPadding: ui.du(1.0)
            topPadding: ui.du(2.0)
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: .8
                }
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                Container {
                    Label {
                        id: name
                        multiline: true
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 9.5
                        textStyle.fontWeight: FontWeight.W300
                        textStyle.fontStyle: FontStyle.Normal
                    }
                }
                Container {
                    Label {
                        id: desc
                        multiline: true
                        opacity: .8
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 8
                        textStyle.fontWeight: FontWeight.W200
                    }
                }
                Container {
                    bottomPadding: 10
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Container {
                        Label {
                            minWidth: 150
                            text: "Last Update at"
                            textStyle.fontSize: FontSize.PointValue
                            textStyle.fontSizeValue: 5
                            opacity: .8

                        }
                    }
                    Container {
                        Label {
                            id: updatedat
//                            text: "datedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedatedate"
                            textStyle.fontSize: FontSize.PointValue
                            textStyle.fontSizeValue: 5
                            opacity: .5
                        }
                    }
                }
            }

            Container {
                maxHeight: 50
                maxWidth: 50
                minHeight: 50
                minWidth: 50
                layoutProperties: StackLayoutProperties {
                    spaceQuota: .2

                }
                ImageView {
                    id: favi
                    horizontalAlignment: HorizontalAlignment.Right
                    verticalAlignment: VerticalAlignment.Center
                    imageSource: "asset:///images/BBicons/ic_heartblack.png"
                    filterColor: Color.White
                }

            }
        }

        Container {

            horizontalAlignment: HorizontalAlignment.Fill
            maxHeight: 3
            minHeight: 3
            background: Color.create("#dcd9d3")
        }
    }
}
