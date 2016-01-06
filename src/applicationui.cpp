/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
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

#include "applicationui.hpp"
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <QtNetwork/QNetworkConfigurationManager>
#include <QtNetwork/QNetworkConfiguration>
#include <QtSql/QSqlQuery>
using namespace bb::cascades;

ApplicationUI::ApplicationUI() :
        QObject(),db(new Database(this)),DM(new DownloadManager(this))
{
    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);

    bool res = QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()));
    // This is only available in Debug builds
    Q_ASSERT(res);
    // Since the variable is not used in the app, this is added to avoid a
    // compiler warning
    Q_UNUSED(res);

    // initial load
    onSystemLanguageChanged();

    Init();
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("Kritus_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}
void ApplicationUI::logincomplete()
{
    mainView();
}
void ApplicationUI::mainView()
{
    qDebug() << ": at main";
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    // Make app available to the qml.
    qml->setContextProperty("app", this);
    QDeclarativePropertyMap *filepathname = new QDeclarativePropertyMap(this);
    filepathname->insert("data", QVariant(QString("file://" + QDir::homePath())));
    qml->setContextProperty("filepathname", filepathname);
    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    Application::instance()->setScene(root);
}

void ApplicationUI::insertSettings(QString type, QString value)
{

    int count = db->getTableSizeByQuery(
            QString("select count(*) from settings where type = \"%1\"").arg(type));
    QVariantMap map;
    map["type"] = type;
    map["value"] = value;
    if (count > 0) {

        db->insertQuery("update settings set value = :value where type = :type", map);
    } else {
        db->insertQuery("insert into settings(type,value) values(:type,:value)", map);
    }
}
void ApplicationUI::Init()
{
    int count = db->getTableSizeByQuery(
            "select count(*) from settings where type = \"access\" or type = \"refresh\"");
    if (count > 0) {
        mainView();
    } else {
        Login();
    }
}
void ApplicationUI::Login()
{

    QmlDocument *qml = QmlDocument::create("asset:///login.qml").parent(this);

    // Make app available to the qml.
    qml->setContextProperty("app", this);

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    Application::instance()->setScene(root);
    qDebug() << ": at login";
}
QString ApplicationUI::getToken()
{
    QSqlQuery query = db->executeSqlQuery(
            QString("select value from settings where type = \"access\""));
    QString token;
    while (query.next()) {
        token = query.value(0).toString();
    }
    return token;
}
void ApplicationUI::downloadFile(QString url,QString filename,QString token){
    DM->TOKEN=token;
    DM->append(QUrl(url),filename);
}
void ApplicationUI::logout(){
   db->deleteTable("settings");
}
void ApplicationUI::callMain(){
    mainView();
}
