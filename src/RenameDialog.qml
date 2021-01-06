/*
 * Copyright (c) 2020 Open Mobile Platform LLC.
 *
 * License: Proprietary
 */
import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.FileManager 1.0

Dialog {
    id: dialog

    property alias oldPath: fileInfo.file

    readonly property var _regExp: new RegExp("[\/*\?<>\|]+")

    function _suffixForFileName(fileName) {
        var suffix = FileEngine.extensionForFileName(fileName)
        return suffix !== "" ?  "." + suffix : suffix
    }

    function _renameFile(fileName) {
        var newPath = fileInfo.directoryPath + '/' + fileName

        if (newPath === oldPath) {
            return
        } else if (FileEngine.exists(newPath)) {
            var suffix = _suffixForFileName(fileName)

            var baseName = fileName.slice(0, fileName.length - suffix.length)

            var counter = 0
            do {
                counter++
                var incrementedFileName = baseName + "(%1)".arg(counter) + suffix

                newPath = fileInfo.directoryPath + '/' + incrementedFileName

                if (newPath === oldPath) {
                    return
                }
            } while (FileEngine.exists(newPath))
        }
        FileEngine.rename(oldPath, newPath)
    }

    FileInfo {
        id: fileInfo
    }

    DialogHeader {
        id: dialogHeader
        //% "Rename"
        title: qsTrId("filemanager-he-rename")
    }

    TextField {
        id: fileName

        width: parent.width
        anchors.top: dialogHeader.bottom
        label: errorHighlight
               //% "Invalid file name"
               ? qsTrId("filemanager-te-invalid_filename")
               //% "Title"
               : qsTrId("filemanager-la-title")

        placeholderText: qsTrId("filemanager-la-title")
        onFocusChanged: {
            if (focus) {
                var suffix = _suffixForFileName(text)

                select(0, text.length - suffix.length)
            }
        }

        text: fileInfo.fileName
        errorHighlight: dialog._regExp.test(text)

        EnterKey.iconSource: "image://theme/icon-m-enter-accept"
        EnterKey.enabled: text !== ""
        EnterKey.onClicked: accept()

        Component.onCompleted: {
            focus = true
        }
    }

    canAccept: !fileName.errorHighlight && fileName.text !== ""
    onAccepted: _renameFile(fileName.text)
}
