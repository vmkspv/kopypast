/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import "." as Local

PlasmoidItem {
    id: root

    preferredRepresentation: compactRepresentation

    property string searchQuery: ""

    QtObject {
        id: clipboard
        property string content: ""
        onContentChanged: {
            if (content) {
                clipboardHelper.text = content
                clipboardHelper.selectAll()
                clipboardHelper.copy()
                content = ""
            }
        }
    }

    TextEdit {
        id: clipboardHelper
        visible: false
    }

    Local.SnippetModel {
        id: snippetModel
        Component.onCompleted: loadFromConfig(plasmoid.configuration.snippets)
        onConfigValueChanged: plasmoid.configuration.snippets = configValue
    }

    Connections {
        target: plasmoid.configuration
        function onSnippetsChanged() {
            snippetModel.loadFromConfig(plasmoid.configuration.snippets)
        }
    }

    compactRepresentation: Item {
        Kirigami.Icon {
            anchors.fill: parent
            source: Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast.svg")
            active: mouseArea.containsMouse
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.expanded = !root.expanded
        }
    }

    fullRepresentation: ColumnLayout {
        id: fullRep
        Layout.minimumWidth: Kirigami.Units.gridUnit * 20
        Layout.minimumHeight: Kirigami.Units.gridUnit * 18
        Layout.preferredWidth: Kirigami.Units.gridUnit * 20
        Layout.preferredHeight: Kirigami.Units.gridUnit * 28
        Layout.maximumWidth: Kirigami.Units.gridUnit * 24
        Layout.maximumHeight: Screen.height
        spacing: 0

        PlasmaComponents.TextField {
            id: searchField
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.smallSpacing
            placeholderText: i18n("Search for snippets...")
            clearButtonShown: true
            onTextChanged: root.searchQuery = text

            Kirigami.Icon {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: Kirigami.Units.smallSpacing
                }
                width: Kirigami.Units.iconSizes.small
                height: width
                source: "search"
            }
            leftPadding: Kirigami.Units.iconSizes.small + (2 * Kirigami.Units.smallSpacing)
        }

        PlasmaComponents.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            contentItem: ListView {
                id: snippetList
                model: {
                    if (!root.searchQuery) return snippetModel.snippets
                    return snippetModel.snippets.filter(snippet =>
                        snippet.title.toLowerCase().includes(root.searchQuery.toLowerCase()) ||
                        snippet.text.toLowerCase().includes(root.searchQuery.toLowerCase())
                    )
                }
                clip: true

                Kirigami.PlaceholderMessage {
                    anchors.centerIn: parent
                    visible: snippetModel.count === 0 && !root.searchQuery
                    width: parent.width - (Kirigami.Units.largeSpacing * 4)
                    icon {
                        source: Kirigami.Theme.textColor.hslLightness < 0.5
                            ? Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast-light.svg")
                            : Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast-dark.svg")
                        color: Kirigami.Theme.textColor
                    }
                    text: i18n("No snippets available")
                    explanation: i18n("Add snippets in the settings")
                }

                Kirigami.PlaceholderMessage {
                    anchors.centerIn: parent
                    visible: snippetList.count === 0 && root.searchQuery
                    width: parent.width - (Kirigami.Units.largeSpacing * 4)
                    icon.name: "search-symbolic"
                    icon.color: Kirigami.Theme.textColor
                    text: i18n("No matching snippets")
                    explanation: i18n("Try a different search term")
                }

                delegate: Kirigami.SwipeListItem {
                    id: snippetDelegate
                    width: ListView.view.width

                    contentItem: ColumnLayout {
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

                    onClicked: {
                        clipboard.content = modelData.text
                        root.expanded = false
                    }
                }
            }
        }

        PlasmaComponents.ToolBar {
            Layout.fillWidth: true
            position: PlasmaComponents.ToolBar.Footer

            RowLayout {
                anchors.fill: parent
                spacing: Kirigami.Units.smallSpacing

                PlasmaComponents.Label {
                    Layout.leftMargin: Kirigami.Units.smallSpacing
                    text: i18np("%1 snippet", "%1 snippets", snippetModel.count)
                    opacity: 0.6
                }

                Item { Layout.fillWidth: true }

                PlasmaComponents.ToolButton {
                    icon.name: "configure"
                    display: PlasmaComponents.AbstractButton.IconOnly
                    onClicked: plasmoid.internalAction("configure").trigger()
                    PlasmaComponents.ToolTip.text: i18n("Configure")
                    PlasmaComponents.ToolTip.visible: hovered
                    PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
                }
            }
        }
    }
}