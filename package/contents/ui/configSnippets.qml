/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils
import org.kde.kirigami as Kirigami
import "." as Local

SimpleKCM {
    id: snippetsPage

    property string cfg_snippets: "[]"
    property string cfg_snippetsDefault: "[]"

    property var deletedSnippet: null
    property int deletedIndex: -1

    Binding {
        target: snippetModel
        property: "configValue"
        value: cfg_snippets
    }

    Local.SnippetModel {
        id: snippetModel
        onConfigValueChanged: cfg_snippets = configValue
    }

    function deleteSnippet(index) {
        deletedSnippet = snippetModel.get(index)
        deletedIndex = index
        snippetModel.remove(index)

        var title = deletedSnippet.title.length > 20
            ? deletedSnippet.title.substring(0, 20) + "..."
            : deletedSnippet.title

        applicationWindow().showPassiveNotification(
            i18n("Snippet \"%1\" deleted", title), 5000, i18n("Undo"), function() {
                undoDelete()
            }
        )
    }

    function undoDelete() {
        if (deletedSnippet && deletedIndex >= 0) {
            var insertIndex = Math.min(deletedIndex, snippetModel.count)
            snippetModel.snippets.splice(insertIndex, 0, deletedSnippet)
            snippetModel.configValue = JSON.stringify(snippetModel.snippets)

            deletedSnippet = null
            deletedIndex = -1
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Kirigami.PlaceholderMessage {
                anchors.centerIn: parent
                width: parent.width - (Kirigami.Units.largeSpacing * 4)
                visible: snippetModel.count === 0
                icon {
                    source: Kirigami.Theme.textColor.hslLightness < 0.5
                        ? Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast-light.svg")
                        : Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast-dark.svg")
                    color: Kirigami.Theme.textColor
                }
                text: i18n("No snippets added")
                explanation: i18n("Add your first snippet using the button below")
            }

            ScrollView {
                anchors.fill: parent
                visible: snippetModel.count > 0

                ListView {
                    id: snippetList
                    model: snippetModel.snippets
                    clip: true

                    move: Transition {
                        NumberAnimation {
                            properties: "y"
                            duration: Kirigami.Units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }

                    moveDisplaced: Transition {
                        NumberAnimation {
                            properties: "y"
                            duration: Kirigami.Units.longDuration
                            easing.type: Easing.InOutQuad
                        }
                    }

                    delegate: Item {
                        id: wrapper
                        width: ListView.view.width
                        height: snippetDelegate.implicitHeight

                        Kirigami.SwipeListItem {
                            id: snippetDelegate
                            width: parent.width
                            swipe.enabled: false

                            contentItem: RowLayout {
                                spacing: Kirigami.Units.smallSpacing

                                Kirigami.ListItemDragHandle {
                                    listItem: snippetDelegate
                                    listView: snippetList
                                    visible: snippetList.count > 1
                                    onMoveRequested: function(oldIndex, newIndex) {
                                        snippetModel.move(oldIndex, newIndex)
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true

                                    Label {
                                        Layout.fillWidth: true
                                        text: modelData.title
                                        elide: Text.ElideRight
                                        maximumLineCount: 1
                                    }

                                    Label {
                                        Layout.fillWidth: true
                                        text: modelData.text
                                        elide: Text.ElideRight
                                        maximumLineCount: 1
                                        opacity: 0.7
                                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                                    }
                                }

                                RowLayout {
                                    spacing: Kirigami.Units.smallSpacing
                                    Layout.rightMargin: Kirigami.Units.smallSpacing

                                    ToolButton {
                                        icon.name: "document-edit"
                                        display: ToolButton.IconOnly
                                        onClicked: snippetDialog.editSnippet(index)
                                        ToolTip.text: i18n("Edit")
                                        ToolTip.visible: hovered
                                        ToolTip.delay: Kirigami.Units.toolTipDelay
                                    }

                                    ToolButton {
                                        icon.name: "edit-delete"
                                        display: ToolButton.IconOnly
                                        onClicked: deleteSnippet(index)
                                        ToolTip.text: i18n("Delete")
                                        ToolTip.visible: hovered
                                        ToolTip.delay: Kirigami.Units.toolTipDelay
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.smallSpacing

            Button {
                icon.name: "list-add"
                text: i18n("Add Snippet")
                onClicked: snippetDialog.createSnippet()
                enabled: snippetModel.count < plasmoid.configuration.maxSnippets
                ToolTip.text: i18n("Maximum limit reached")
                ToolTip.visible: !enabled && hovered
                ToolTip.delay: Kirigami.Units.toolTipDelay
            }

            Item { Layout.fillWidth: true }

            Button {
                icon.name: "document-export"
                text: i18n("Backup")
                onClicked: {
                    backupDialog.isBackup = true
                    backupDialog.open()
                }
            }

            Button {
                icon.name: "document-import"
                text: i18n("Restore")
                onClicked: {
                    backupDialog.isBackup = false
                    backupDialog.open()
                }
            }
        }
    }

    SnippetDialog {
        id: snippetDialog
        parent: snippetsPage
        width: Math.min(snippetsPage.width - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
        height: Math.min(snippetsPage.height - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
    }

    BackupDialog {
        id: backupDialog
        parent: snippetsPage
        width: Math.min(snippetsPage.width - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
        height: Math.min(snippetsPage.height - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
    }
}