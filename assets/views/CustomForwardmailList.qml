import bb.cascades 1.4

Container {
    Container {
        background: Color.Gray
        preferredHeight: 2
        horizontalAlignment: HorizontalAlignment.Fill
    }
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

            background: Color.Blue
            preferredHeight: 130
            preferredWidth: 100
        }
        Container {
            leftPadding: 130
            Container {
                Label {
                    text: "Subject MAil"
                    textStyle.fontSize: FontSize.Medium
                    textStyle.fontWeight: FontWeight.W500
                }
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                topPadding: 3
                Label {
                    opacity: 0.7

                    text: qsTr("From :")
                }
                Label {
                    //From Adress Name SENDER NAME
                    opacity: 0.7
                    text: "mail NAme"
                }

            }
            Container {

                topPadding: 3
                Container {
                    //EMAIL HERE... SENDER EMAIL
                    Label {
                        multiline: true
                        opacity: 0.7
                        text: "emailhere via "
                    }
                }
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    Container {
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        Label {
                            //USERENAME
                            opacity: 0.7
                            text: "HOLYBESASR via akjdsjhbjashdvba,jHDBVjasdv"
                        }
                    }
                    Container {

                        layoutProperties: StackLayoutProperties {
                        }
                        Label { //DATEEE
                            opacity: 0.7
                            text: "eTIME TIME  gba "
                        }
                    }

                }

            }
        }
    }
}
