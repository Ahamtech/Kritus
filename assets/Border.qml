import bb.cascades 1.4

    Container {
        id: bordercontainer
        property alias bordercolor:bordercontainer.background
        property variant points
        background: bordercolor
        topPadding: points
        rightPadding: points
        leftPadding: points
        bottomPadding: points
       
    }
