import bb.cascades 1.4

Container {
    
    property alias description:desc.text
    property alias fileName:filename.text
    property alias imageSize:filesize.text
    property alias imageType:imagetype.text
    property alias dateTime:datetime.text
    property alias user:username.text
    
    
//    background: Color.create("#fbf8f5")
    
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)
    Container {
        topPadding: ui.du(1)
        
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        minHeight: 170
        layout: DockLayout {
        
        }
        
        Container {
            horizontalAlignment: HorizontalAlignment.Left
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
                    id : userimage
                    imageSource: "asset:///images/new/loginimage.png"
                
                }
            }
            Container {
                topPadding: 5
                preferredHeight: 80
                preferredWidth: 80
                ImageView {
//                    filterColor: Color.create("#fbf8f5")
                    
                    imageSource: "asset:///images/new/pic.png"
                }
            }
        
        }
        Container {
            bottomPadding: ui.du(1.0)
            Container {
                
                leftPadding: 100
                verticalAlignment: VerticalAlignment.Top
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Container {
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        Label {
                            id: username
                            text: "Hoasdasdbt said ...posted by"
                            textStyle.fontSize: FontSize.Medium
                            textStyle.fontStyle: FontStyle.Default
                            textStyle.fontWeight: FontWeight.W500
                        }
                    }
                    Container {
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        horizontalAlignment: HorizontalAlignment.Right
                        Label {
                            horizontalAlignment: HorizontalAlignment.Right
                            id: datetime
                            opacity: 0.7
                            textStyle.fontWeight: FontWeight.W300
                            text: "date whats "
                        }
                    }
                }
                Container {
                    //Discussion Item
                    Label {
                        id: desc
                        text: "asdfgh"
                        textStyle.color: Color.create("#ff00ceff")
                    }
                }
                //Files
                Container {
                    id: imageactivity
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Left
                    Label {
                        id: filename
                        multiline: true
//                        text: "file name ile name ile name ile name ile name ile name ile name ile name "
                    }
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            id: imagetype
                            text: "jpeg"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1
                            }
                        }
                        
                        Label {
                            id: filesize
                            horizontalAlignment: HorizontalAlignment.Right
                            text: "2.4 mb"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1
                            }
                        }
                    
                    }
                }
            }
        
        }
    
    }
    Container {
        background: Color.Gray
        horizontalAlignment: HorizontalAlignment.Fill
        preferredHeight: 2
    
    }
}
