/* Copyright (c) 2012, 2013  BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.4
import bb.system 1.2
import bb.device 1.4
import "js/ajaxmee.js" as Ajaxmee
Page {
    attachedObjects: [

        DisplayInfo {
            id: dispinfo

        }
    ]
    Container {
        topPadding: 40
        bottomPadding: 40
        rightPadding: 40
        leftPadding: 40
        background: log_image.imagePaint
        attachedObjects: [
            ImagePaintDefinition {
                id: log_image
                imageSource: "asset:///images/new/loginkritus.png"
            }

        ]
        Container {

            topPadding: 1
            bottomPadding: 1
            rightPadding: 1
            leftPadding: 1

            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            Container {

                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill

                Container {
                    background: Color.create("#8cffffff")
                    Container {
                        attachedObjects: [
                            SystemToast {
                                id: toast
                                body: "NO Network COnnections"
                            }
                        ]
                        Container {
                            layout: DockLayout {

                            }
                            accessibilityMode: A11yMode.Default
                            ScrollView {
                                scrollViewProperties {
                                    scrollMode: ScrollMode.Both
                                    pinchToZoomEnabled: true
                                }
                                Container {
                                    layout: DockLayout {
                                    }
                                    onCreationCompleted: {
                                        webWindow.storage.clear()
                                    }
                                    WebView {

                                        id: webWindow
                                        onCreationCompleted: {
                                            storage.clear()
                                            storage.clearCache()
                                            storage.clearCookies()
                                            storage.clearCredentials()
                                            
                                        }
                                        onUrlChanged: {
                                        console.log(url.toString())
                                            if (url.toString().indexOf("authorize") > 0 || url.toString().indexOf("approve_access") > 0) {
                                            } else {
                                                if (url.toString().indexOf("localhost") > 0) {
                                                    var items = url.toString().split("?")
                                                    console.log(JSON.stringify(items))
                                                    var cod = items[1].split("=")
                                                    getKey(cod[1])
                                                }
                                            }
                                        }
                                        onLoadProgressChanged: {
                                            webviewprgoress.value = loadProgress / 100
                                            if (loadProgress > 70) {
                                                logger_iamge.visible = false
                                            }
                                        }
                                    }
                                }
                            }
                            ImageView {
                                id: logger_iamge
                                imageSource: "asset:///images/loader.gif"
                                visible: false
                                verticalAlignment: VerticalAlignment.Center
                                horizontalAlignment: HorizontalAlignment.Center
                                minHeight: 200
                                minWidth: 200
                            }

                            ProgressIndicator {
                                id: webviewprgoress
                                value: 0.1
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Bottom
                            }
                            Container {
                                id: wunderlistloading
                                verticalAlignment: VerticalAlignment.Center
                                horizontalAlignment: HorizontalAlignment.Center
                                ImageView {
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Center
                                    imageSource: "asset:///kritusiconb.png"
                                    minHeight: 150
                                    minWidth: 150
                                    maxHeight: 150
                                    maxWidth: 150
                                }

                                Container {
                                    bottomPadding: 30
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Center
                                    Label {
                                        text: "Kritus"

                                        textStyle.fontSizeValue: 0.0
                                        textStyle.color: Color.DarkYellow
                                        textStyle.fontSize: FontSize.XXLarge
                                    }
                                }
                                Container {
                                    horizontalAlignment: HorizontalAlignment.Center
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    Button {
                                        verticalAlignment: VerticalAlignment.Center
                                        horizontalAlignment: HorizontalAlignment.Center
                                        maxWidth: 500
                                        minWidth: 500
                                        text: qsTr("Login Here") + Retranslate.onLanguageChanged
                                        onClicked: {
                                            logger_iamge.visible = true
                                            wunderlistloading.visible = false
                                            var item = "https://launchpad.37signals.com/authorization/new?type=web_server&client_id=acecf992ed731db5f013380afeb012fbaeca1640&redirect_uri=http://localhost"
                                            webWindow.url = item
                                            webWindow.preferredHeight = dispinfo.resolution.height
                                            webWindow.preferredWidth = dispinfo.resolution.width
                                        }
                                    }

                                }
                                Container {
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Center
                                    leftPadding: 60
                                    rightPadding: 60
                                    topPadding: 30

                                    Label {
                                        text: qsTr("We will redirect you to Basecamp website to authorise access for Kritus")
                                        multiline: true
                                        textStyle.color: Color.DarkRed
                                        textStyle.fontSize: FontSize.Small
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
    }
    function getKey(code) {
        console.log(code)
        var doc = new XMLHttpRequest();
        var url = "https://launchpad.37signals.com/authorization/token?type=web_server&client_id=acecf992ed731db5f013380afeb012fbaeca1640&redirect_uri=http://localhost&client_secret=c79c9337229b32968976f1916229cf040a8c0e59&code=" + code
        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                if (doc.status == 200) {
                    var data = JSON.parse(doc.responseText)
                    console.log(doc.responseText)
                    console.log(data['access_token'])
                    console.log(data['refresh_token'])
                    app.insertSettings('access', data['access_token'])
                    app.insertSettings('refresh', data['refresh_token'])
                    app.callMain()
                } else {
                    console.log(doc.responseText)
                }
            }
        }
        doc.open("POST", url);
        doc.setRequestHeader("Content-Type", "apappplication/json");
        doc.setRequestHeader("User-Agent", "BB10");
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send();
    }
}
