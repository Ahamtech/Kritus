import bb.cascades 1.4

Container {
    horizontalAlignment: HorizontalAlignment.Fill
    property alias dtime : datetime.text
    property alias title : doctitle.text
//    property alias userName : username.text
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)

    verticalAlignment: VerticalAlignment.Center
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {

        }
        Container {
            topPadding: 5
            /* ImageView {
             * imageSource: "asset:///images/new/blackrecbor.png"
             }*/

            background: Color.Yellow
            preferredHeight: 130
            preferredWidth: 100
        }
        Container {
            leftPadding: 130
            Container {
                Label {
                    id: doctitle
                    text: " title"
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.W500
                }
            }
//            Container {
//                topPadding: 3
//                Label {
//                    id: username
//                    //REcent Activity by UserNAmE
//                    opacity: 0.7
//                    text: "username"
//                }
//
//            }
            Container {
                topPadding: 3
                Label {
                    id: datetime
                    //date of last activity
                    opacity: 0.7
                    text: "Date"
                }

            }
        }
    }
//    Container {
//        background: Color.Gray
//        preferredHeight: 2
//        horizontalAlignment: HorizontalAlignment.Fill
//    }
}
