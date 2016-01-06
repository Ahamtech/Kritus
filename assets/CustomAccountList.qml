import bb.cascades 1.4

Container {
    property alias title: name.text
    leftPadding: ui.du(2.0)
    bottomPadding: ui.du(3.0)
    Container {
        bottomPadding: 2
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        visible: true
        background: Color.LightGray
        Container {
            background: Color.White
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            leftPadding: ui.du(2.0)
            topMargin: ui.du(2.0)
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                Container {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: .8
                    }
                    bottomPadding: 20
                    topPadding: 20
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Container { //icon
                        maxHeight: 60
                        maxWidth: 60
                        opacity: .5
                        ImageView {
                            imageSource: "asset:///images/new/accountsmain.png"
                        }
                    }

                    Container { //account name
                        leftPadding: 20
                        
                        Label {
                            id: name
                            textStyle.fontSize: FontSize.PointValue
                            textStyle.fontSizeValue: 9.5
                            textStyle.fontWeight: FontWeight.W300
                            textStyle.fontStyle: FontStyle.Normal
                        }
                    }

                }

            }

        }
    }
}