import bb.cascades 1.3

Container {
    property alias commenttext: comment.text
    property alias usertext: name.text
    property alias commenttime: clock.text
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)
    Container {
        background: Color.White
        horizontalAlignment: HorizontalAlignment.Fill
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight

            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom

                }
                topPadding: ui.du(2.0)

                bottomPadding: ui.du(2.0)
                leftPadding: ui.du(2.0)
                rightPadding: ui.du(2.0)
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight

                    }
                    Container {
                        layout: AbsoluteLayout {

                        }
                        verticalAlignment: VerticalAlignment.Top

                        /*maxHeight: 100
                         maxWidth: 100*/
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
                                imageSource: "asset:///images/new/pic.png"
                            }
                        }

                    }

                    Container {
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom

                        }
                        leftPadding: 10
                        Container {
                            topPadding: 1
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight

                            }
                            Label {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                id: name
                                text: ""
                                textStyle.color: Color.create("#477b96")
                                textStyle.fontWeight: FontWeight.W500
                                textStyle.fontSize: FontSize.Small
                                textStyle.fontFamily: "Calibri"
                                textStyle.fontStyle: FontStyle.Normal

                            }
                            Container {
                                rightPadding: 5
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight

                                }
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: -1
                                }
                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight

                                    }
                                    topPadding: 5

                                    Label {

                                        id: clock
                                        text: ""
                                        textStyle.fontSize: FontSize.XXSmall
                                        textStyle.fontSizeValue: 4.8
                                        textStyle.fontFamily: "Calibri"
                                        textStyle.fontStyle: FontStyle.Normal
                                        textStyle.color: Color.create("#68b38b")
                                        textStyle.fontWeight: FontWeight.W600

                                    }
                                }

                            }
                        }

                        Container {
                            Label {
                                id: comment
                                text: ""
                                multiline: true
                                textFormat: TextFormat.Html
                                textStyle.fontFamily: "Calibri"
                                textStyle.fontWeight: FontWeight.W400

                            }
                        }

                    }

                }

            }
        }

    }
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        minHeight: 2
        background: Color.create("#dcd9d3")
    }
}
