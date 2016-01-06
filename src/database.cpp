/*
 * database.cpp
 *
 *  Created on: 17-Dec-2014
 *      Author: perl
 */
#include "database.hpp"
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>
#include <QtSql/QSqlError>
#include <QtSql/QtSql>
#include <QDate>
#include <QDebug>
#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <bb/data/SqlDataAccess>
using namespace bb::cascades;
using namespace bb::data;

//class bb::cascades::GroupDataModel;
Database::Database(QObject *parent) :
        QObject(parent), DB_PATH("./data/Kritus.db")
{
    sqlda = new SqlDataAccess(DB_PATH);
    qDebug() << "thisi is the DB" << DB_PATH;
    initDatabase();
}
Database::~Database()
{
}
bool Database::openDatabase()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(DB_PATH);
    qDebug() << db.isValid();
    qDebug() << db.open();
    bool ok = db.open();
    if(ok){
        KRITUS_TABLES=db.tables(QSql::Tables);
    }
    return ok;
}
bool Database::initDatabase()
{ //call this method with the name of the database with
    if (openDatabase()) {
        qDebug() << "Kritus database  created";

        QString settingsTable =
                "create table if not exists settings(type varchar primary key unique,value varchar)";
        QSqlQuery queryAuths(settingsTable);

        qDebug() << " settings table created" << queryAuths.isActive();

        return true;
    } else
        return false;
}

QVariant Database::executeQuery(QString q)
{
    return sqlda->execute(q);
}
QSqlQuery Database::executeSqlQuery(QString q)
{
    QSqlQuery query(q);
    return query;
}

GroupDataModel * Database::getQueryModel(QString query)
{
    GroupDataModel *model = new GroupDataModel(QStringList());
    QVariant data = sqlda->execute(query);
    model->insertList(data.value<QVariantList>());
    return model;
}
int Database::getTableSizeByQuery(QString query)
{
    QSqlQuery q;
    q.prepare(query);
    if (q.exec()) {
        int rows = 0;
        if (q.next()) {
            rows = q.value(0).toInt();
        }
        return rows;
    } else
        qDebug() << q.lastError();
}
int Database::getTableSize(QString tabname)
{
    QSqlQuery q;
    q.prepare(QString("SELECT COUNT (*) FROM %1").arg(tabname));
    if (q.exec()) {
        int rows = 0;
        if (q.next()) {
            rows = q.value(0).toInt();
        }
        return rows;
    } else
        qDebug() << q.lastError();
}

bool Database::insertQuery(QString query, QVariantMap bind)
{
    sqlda->execute(query, bind);
    return sqlda->hasError();
}

void Database::deleteTable(QString tablename){
    QSqlQuery q(QString("delete from  %1").arg(tablename));
}
