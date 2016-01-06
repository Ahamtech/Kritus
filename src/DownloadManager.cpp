/*
 * DownloadManagers.cpp
 *
 *  Created on: 21-Feb-2015
 *      Author: ROG
 */
#include "DownloadManager.hpp"
#include <QDir>
#include <QDebug>
DownloadManager::DownloadManager(QObject *parent)
    : QObject(parent)
{
    cache.setMaximumCacheSize(CACHE_SIZE);
    cache.setCacheDirectory("/accounts/1000/shared/misc/Kritus");
    manager.setCache(&cache);
}

void DownloadManager::append(const QUrl& url, const QString& filename)
{
    queue.enqueue(qMakePair(url, filename));
    nextDownload();
}

void DownloadManager::remove(const QString& filename)
{
    QFile *file = downloads[filename];
    file->close();
    file->deleteLater();
    downloads.remove(filename);
}

void DownloadManager::nextDownload()
{
    if (downloads.size() < MAX_DOWNLOADS && !queue.empty()) {
        QPair<QUrl, QString> download = queue.dequeue();
        QUrl url = download.first;
        QString filename = "./data/ahammedia/"+download.second;

        if (downloads.contains(filename))
            return;
        QFile *file = new QFile(filename,this);

        if (!file->open(QIODevice::ReadWrite)) {
            qErrnoWarning("Error while opening %s for write", qPrintable(filename));
            delete file;
            return;
        }
        QNetworkRequest request(url);
        request.setRawHeader(QString("Authorization").toLatin1(),QString("Bearer " +TOKEN).toLatin1());
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        request.setAttribute(QNetworkRequest::User, filename);
        request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);

        QNetworkReply *reply = manager.get(request);
        connect(reply, SIGNAL(readyRead()), SLOT(readReady()));
        connect(reply, SIGNAL(downloadProgress(qint64,qint64)), SLOT(downloadProgress(qint64,qint64)));
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(error(QNetworkReply::NetworkError)));
        connect(reply, SIGNAL(finished()), SLOT(finished()));

        downloads.insert(filename, file);
    }
}

void DownloadManager::readReady()
{
    if (QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender())) {
        QString filename = reply->request().attribute(QNetworkRequest::User).toString();
        if (downloads.contains(filename)) {
            QFile *file = downloads.value(filename);
            file->write(reply->readAll());
        }
    }
}

void DownloadManager::downloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    qDebug()<<"bytes received"<<bytesReceived<<"/"<<bytesTotal;
    Q_UNUSED(bytesReceived);
    Q_UNUSED(bytesTotal);
}

void DownloadManager::error(QNetworkReply::NetworkError code)
{
    Q_UNUSED(code);
    if (QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender())) {
        qErrnoWarning("Error!");

        QString filename = reply->request().attribute(QNetworkRequest::User).toString();
        remove(filename);
        reply->deleteLater();
    }
}

void DownloadManager::finished()
{
    if (QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender())) {
        QString filename = reply->request().attribute(QNetworkRequest::User).toString();
        remove(filename);
        reply->deleteLater();
        nextDownload();
    }
}



