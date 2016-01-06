import bb.cascades 1.4

Container {
    property alias timetext : week.text
    property alias eventName : eventname.text
    property alias daytext : day.text
    property alias monthtext :month.text
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Center
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        layout: DockLayout {
        
        }
        Container {
            topPadding: 5
            ImageView {
                imageSource: "asset:///images/new/blackrecbor.png"
            }
            layout: DockLayout {
            
            }
            Label {
                id: month
                text: "MAR"
                textStyle.color: Color.White
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Top
            }
          Container {
              horizontalAlignment: HorizontalAlignment.Center
              verticalAlignment: VerticalAlignment.Center
              topPadding: 25
              Label {
                  id: day
                  text: "17"
                  textStyle.color: Color.White
                  horizontalAlignment: HorizontalAlignment.Center
                  verticalAlignment: VerticalAlignment.Center
              }
          }
        }
        Container {
            leftPadding: 130
            Container {
                Label {
                    id: eventname
                    text: "Event Name"
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.W500
                }
            }
            Container {
                topPadding: 5
                
                Label {
                    id: week
                    opacity: 0.7
                    text: "wednesday"
                }
            
            }
        
        }
    
    }
   /* Container {
        
        background: Color.Gray
        horizontalAlignment: HorizontalAlignment.Fill
        preferredHeight: 2
    }*/
}
