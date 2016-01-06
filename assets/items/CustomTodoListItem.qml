import bb.cascades 1.4

Container {
    topPadding: 10
    bottomPadding: 10
    property  alias listname: listnam.text
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    signal completed
    signal incompleted
    Container {
        verticalAlignment: VerticalAlignment.Center
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            verticalAlignment: VerticalAlignment.Center

            CheckBox {
                verticalAlignment: VerticalAlignment.Center
                onCheckedChanged: {
                    if(checked)
                        completed()
                    else
                        incompleted()
                }
            }
        }
        Container {
            verticalAlignment: VerticalAlignment.Center
            leftPadding: 30
            Label {
                id: listnam
//                text: "adsfad alk dfal dfalk fdja;l dfja;djf "
            }
        }
    }

}
