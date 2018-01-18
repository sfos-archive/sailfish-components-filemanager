pragma Singleton

import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.FileManager 1.0
import org.nemomobile.contentaction 1.0

Item {
    id: root

    property PageStack pageStack

    /*!
    \internal

    Implementation detail for file manager
    */
    property FileManagerNotification errorNotification

    // Call before start to use
    function init(pageStack) {
        root.pageStack = pageStack
    }

    function openDirectory(properties) {
        if (!properties.hasOwnProperty("errorNotification")) {
            createErrorNotification()
            properties["errorNotification"] = root.errorNotification
        }

        return pageStack.push(Qt.resolvedUrl("DirectoryPage.qml"), properties)
    }

    function openUrlExternally(url) {
        createErrorNotification()
        var ok = ContentAction.trigger(url)
        if (!ok) {
            switch (ContentAction.error) {
            case ContentAction.FileTypeNotSupported:
                //: Notification text shown when user tries to open a file of a type that is not supported
                //% "Cannot open file, file type not supported"
                errorNotification.show(qsTrId("filemanager-la-file_type_not_supported"))
                break
            case ContentAction.FileDoesNotExist:
                //: Notification text shown when user tries to open a file but the file is not found locally.
                //% "Cannot open file, file was not found"
                errorNotification.show(qsTrId("filemanager-la-file_not_found"))
                break
            default:
                //% "Error opening file"
                errorNotification.show(qsTrId("filemanager-la-file_generic_error"))
                break
            }
        }
    }

    function openArchive(file, path, baseExtractionDirectory, stackAction) {
        createErrorNotification()
        stackAction = stackAction || PageStackAction.Animated

        var properties = {
            archiveFile: file,
            path: path || "/",
            errorNotification: errorNotification
        }

        if (baseExtractionDirectory) {
            properties["baseExtractionDirectory"] = baseExtractionDirectory
        }

        return pageStack.push(Qt.resolvedUrl("ArchivePage.qml"), properties, stackAction)
    }

    function createErrorNotification() {
        if (!errorNotification) {
            errorNotification = errorNotificationComponent.createObject(root)
        }
    }

    Component {
        id: errorNotificationComponent

        FileManagerNotification {}
    }
}
