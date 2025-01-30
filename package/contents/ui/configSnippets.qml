/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.kcmutils
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import "." as Local

SimpleKCM {
    id: snippetsPage

    property string cfg_snippets: "[]"
    property string cfg_snippetsDefault: "[]"

    Binding {
        target: snippetModel
        property: "configValue"
        value: cfg_snippets
    }

    Local.SnippetModel {
        id: snippetModel
        onConfigValueChanged: cfg_snippets = configValue
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.preferredWidth: Kirigami.Units.gridUnit * 20
    Layout.preferredHeight: Kirigami.Units.gridUnit * 20

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

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

            PlasmaComponents.ScrollView {
                anchors.fill: parent
                visible: snippetModel.count > 0

                ListView {
                    id: snippetList
                    model: snippetModel.snippets
                    interactive: true
                    clip: true

                    delegate: Kirigami.SwipeListItem {
                        id: snippetDelegate
                        width: ListView.view.width
                        swipe.enabled: false

                        contentItem: RowLayout {
                            spacing: Kirigami.Units.smallSpacing

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                PlasmaComponents.Label {
                                    Layout.fillWidth: true
                                    text: modelData.title
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                }

                                PlasmaComponents.Label {
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

                                PlasmaComponents.ToolButton {
                                    icon.name: "document-edit"
                                    display: PlasmaComponents.ToolButton.IconOnly
                                    onClicked: snippetDialog.editSnippet(index)
                                    PlasmaComponents.ToolTip.text: i18n("Edit")
                                    PlasmaComponents.ToolTip.visible: hovered
                                    PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
                                }

                                PlasmaComponents.ToolButton {
                                    icon.name: "edit-delete"
                                    display: PlasmaComponents.ToolButton.IconOnly
                                    onClicked: snippetModel.remove(index)
                                    PlasmaComponents.ToolTip.text: i18n("Delete")
                                    PlasmaComponents.ToolTip.visible: hovered
                                    PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
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

            PlasmaComponents.Button {
                icon.name: "list-add"
                text: i18n("Add Snippet")
                onClicked: snippetDialog.createSnippet()
            }
            Item { Layout.fillWidth: true }
        }
    }

    SnippetDialog {
        id: snippetDialog
        parent: snippetsPage
        width: Math.min(snippetsPage.width - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
        height: Math.min(snippetsPage.height - Kirigami.Units.gridUnit * 4, Kirigami.Units.gridUnit * 30)
    }
}