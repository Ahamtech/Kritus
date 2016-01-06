import bb.cascades 1.4
Container {
    property alias edate: e_date.text
    topPadding: 30
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)
    Container {

        property alias edate: e_date.text
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.White
        maxHeight: 300
        minHeight: 300
        layout: DockLayout {
        }
        /*Container {
         * verticalAlignment: VerticalAlignment.Top
         * background: Color.create("#dcd9d3")
         * preferredHeight: 15
         * horizontalAlignment: HorizontalAlignment.Fill
         }*/
        Container {
            verticalAlignment: VerticalAlignment.Bottom
            background: Color.create("#dcd9d3")
            preferredWidth: 15
            preferredHeight: 100
            horizontalAlignment: HorizontalAlignment.Center
        }

        Container {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top
            layout: DockLayout {

            }
            ImageView {
                minHeight: 250
                minWidth: 250
                maxHeight: 250
                maxWidth: 250
                imageSource: "asset:///images/new/progress.png"
            }
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                Label {
                    id: e_date
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                }
                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    text: ""
                }
            }
        }
        Container {
            verticalAlignment: VerticalAlignment.Bottom
            bottomPadding: 20

            Label {
            }
        }
        Container {
            verticalAlignment: VerticalAlignment.Bottom

            background: Color.create("#dcd9d3")
            preferredHeight: 15
            horizontalAlignment: HorizontalAlignment.Fill
        }
    }

}