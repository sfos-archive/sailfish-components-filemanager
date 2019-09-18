/*
 * Copyright (c) 2016 – 2019 Jolla Ltd.
 * Copyright (c) 2019 Open Mobile Platform LLC.
 *
 * License: Proprietary
 */
import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.FileManager 1.0
import Nemo.FileManager 1.0

Page {

    property alias fileName: fileNameItem.value
    property alias mimeType: fileTypeItem.value
    property bool isDir
    property date modified
    property double size
    property string path

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingMedium

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                title: isDir ?
                               //% "Directory information"
                               qsTrId("filemanager-he-dir-info")
                               //% "File information"
                             : qsTrId("filemanager-he-file-info")
            }

            DetailItem {
                id: fileNameItem
                //% "Name"
                label: qsTrId("filemanager-he-name")
            }

            DetailItem {
                //% "Size"
                label: qsTrId("filemanager-he-size")
                //: Shown when calculating size of a directory (context menu -> details)
                //% "Calculating…"
                value: du.working ? qsTrId("filemanager-la-calculating") : Format.formatFileSize(size)
            }

            DetailItem {
                id: fileTypeItem
                //% "Type"
                label: qsTrId("filemanager-he-type")
            }

            DetailItem {
                //% "Modified"
                label: qsTrId("filemanager-he-modified")
                value: Format.formatDate(modified, Formatter.DateLong)
            }
        }

        VerticalScrollDecorator {}
    }

    DiskUsage { id: du }

    Component.onCompleted: {
        if (isDir) {
            du.calculate(path, function (usage) {
                size = usage[path]
            })
        }
    }
}
