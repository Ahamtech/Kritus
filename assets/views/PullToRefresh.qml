import bb.cascades 1.4

    Container {
        signal refreshTriggered
        property bool touchActive: false
        
        ImageView {
            id: imgRefreshIcon
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            
            imageSource: "asset:///images/BBicons/ic_reload.png"
            scalingMethod: ScalingMethod.AspectFit
        filterColor: Color.Gray

    }
        Label {
            id: lblRefresh
            text: "Pull down to refresh entries..."
            textStyle.textAlign: TextAlign.Center
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
        }
        
        attachedObjects: [
            LayoutUpdateHandler {
                id: refreshHandler
                onLayoutFrameChanged: {
                    imgRefreshIcon.rotationZ = layoutFrame.y;
                    if (layoutFrame.y >= 0.0) {
                        lblRefresh.text = "Release to refresh"
                        
                        if (layoutFrame.y == 0 && touchActive != true) {
                            refreshTriggered();
                            lblRefresh.text = "Refreshing..."
                        }
                    } else {
                        lblRefresh.text = "Pull down to refresh"
                    }
                }
            }
        ]
    }
