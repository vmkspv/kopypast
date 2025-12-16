/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kirigami.private as KirigamiPrivate
import "." as Local

PlasmoidItem {
    id: root

    preferredRepresentation: plasmoid.formFactor === 2 || plasmoid.formFactor === 3
        ? compactRepresentation
        : fullRepresentation

    property bool isCopied: false
    property string searchQuery: ""
    hideOnWindowDeactivate: !plasmoid.configuration.isPinned

    Local.SnippetModel {
        id: snippetModel
        Component.onCompleted: loadFromConfig(plasmoid.configuration.snippets)
        onConfigValueChanged: plasmoid.configuration.snippets = configValue
    }

    Local.VariableHandler {
        id: variableHandler
    }

    Connections {
        target: plasmoid.configuration
        function onSnippetsChanged() {
            snippetModel.loadFromConfig(plasmoid.configuration.snippets)
        }
        function onSortByUsageChanged() {
            if (!plasmoid.configuration.sortByUsage) {
                snippetModel.resetUsageCount()
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 2000
        onTriggered: root.isCopied = false
    }

    compactRepresentation: Item {
        Kirigami.Icon {
            anchors.fill: parent
            source: plasmoid.configuration.useSymbolicIcon
                ? (Kirigami.Theme.textColor.hslLightness < 0.5
                    ? Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast-light.svg")
                    : Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast-dark.svg"))
                : Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast.svg")
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
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        Layout.minimumHeight: Kirigami.Units.gridUnit * 18
        Layout.preferredWidth: Kirigami.Units.gridUnit * 20
        Layout.preferredHeight: Kirigami.Units.gridUnit * 28
        Layout.maximumWidth: plasmoid.formFactor === 2 || plasmoid.formFactor === 3
            ? Kirigami.Units.gridUnit * 28
            : root.width
        Layout.maximumHeight: plasmoid.formFactor === 2 || plasmoid.formFactor === 3
            ? Kirigami.Units.gridUnit * 42
            : root.height

        Keys.forwardTo: [snippetList]
        focus: !plasmoid.configuration.showSearchField || !searchField.enabled

        Kirigami.SearchField {
            id: searchField
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.smallSpacing
            placeholderText: i18n("Search for snippets...")
            onTextChanged: root.searchQuery = text
            selectByMouse: true
            persistentSelection: false
            Keys.onEscapePressed: {
                clear()
                root.expanded = false
            }
            visible: plasmoid.configuration.showSearchField
            enabled: visible && snippetModel.count > 0
            focus: plasmoid.configuration.showSearchField && plasmoid.configuration.useKbdNavigation
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: snippetList
                property var filteredModel: {
                    var sortedSnippets = snippetModel.getSortedSnippets(plasmoid.configuration.sortByUsage)
                    return root.searchQuery
                        ? sortedSnippets.filter(function(snippet) {
                            return snippet.title.toLowerCase().includes(root.searchQuery.toLowerCase()) ||
                                   snippet.text.toLowerCase().includes(root.searchQuery.toLowerCase())
                          })
                        : sortedSnippets
                }

                Connections {
                    target: plasmoid.configuration
                    function onSortByUsageChanged() {
                        snippetList.filteredModel = Qt.binding(function() {
                            var sortedSnippets = snippetModel.getSortedSnippets(plasmoid.configuration.sortByUsage)
                            return root.searchQuery
                                ? sortedSnippets.filter(function(snippet) {
                                    return snippet.title.toLowerCase().includes(root.searchQuery.toLowerCase()) ||
                                           snippet.text.toLowerCase().includes(root.searchQuery.toLowerCase())
                                  })
                                : sortedSnippets
                        })
                    }
                }

                model: filteredModel
                clip: true
                focus: plasmoid.configuration.useKbdNavigation && !searchField.enabled
                keyNavigationEnabled: plasmoid.configuration.useKbdNavigation
                currentIndex: plasmoid.expanded ? 0 : -1

                function handleSelection() {
                    if (currentIndex >= 0) {
                        var snippet = model[currentIndex]
                        var processedText = variableHandler.processVariables(snippet.text)
                        KirigamiPrivate.CopyHelperPrivate.copyTextToClipboard(processedText)

                        if (plasmoid.configuration.isPinned ||
                            !(plasmoid.formFactor === 2 || plasmoid.formFactor === 3)) {
                            root.isCopied = true
                            resetTimer.restart()
                        }
                        if (plasmoid.formFactor === 2 || plasmoid.formFactor === 3) {
                            if (!plasmoid.configuration.isPinned) {
                                root.expanded = false
                            } else if (plasmoid.configuration.clearSearchOnCopy) {
                                searchField.clear()
                                root.searchQuery = ""
                            }
                        } else if (plasmoid.configuration.clearSearchOnCopy) {
                            searchField.clear()
                            root.searchQuery = ""
                        }

                        var originalIndex = snippetModel.snippets.findIndex(function(s) {
                            return s.title === snippet.title && s.text === snippet.text
                        })
                        if (originalIndex >= 0) {
                            if (plasmoid.configuration.sortByUsage) {
                                snippetModel.incrementUsage(originalIndex)
                            } else {
                                snippetModel.markAsUsed(originalIndex)
                            }
                        }
                    }
                }

                Keys.onEnterPressed: handleSelection()
                Keys.onReturnPressed: handleSelection()

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
                    icon.name: "search"
                    icon.color: Kirigami.Theme.textColor
                    text: i18n("No matching snippets")
                    explanation: i18n("Try a different search term")
                }

                delegate: Kirigami.SwipeListItem {
                    id: snippetDelegate
                    width: ListView.view.width
                    implicitHeight: Kirigami.Units.iconSizes.large + Kirigami.Units.smallSpacing
                    highlighted: plasmoid.configuration.useKbdNavigation && ListView.isCurrentItem

                    contentItem: RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

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
                                visible: !plasmoid.configuration.showOnlyTitles
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.rightMargin: Kirigami.Units.smallSpacing
                            implicitWidth: badgeLabel.implicitWidth + Kirigami.Units.cornerRadius * 2
                            implicitHeight: Math.round(Kirigami.Units.iconSizes.sizeForLabels * 1.3)
                            radius: Kirigami.Units.cornerRadius
                            color: Kirigami.Theme.positiveTextColor
                            visible: plasmoid.configuration.showNewBadges && modelData.isNew

                            Label {
                                id: badgeLabel
                                anchors.centerIn: parent
                                text: i18n("New!")
                                font.bold: true
                                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                            }
                        }
                    }

                    onClicked: {
                        var snippet = modelData
                        var processedText = variableHandler.processVariables(snippet.text)
                        KirigamiPrivate.CopyHelperPrivate.copyTextToClipboard(processedText)

                        if (plasmoid.configuration.isPinned ||
                            !(plasmoid.formFactor === 2 || plasmoid.formFactor === 3)) {
                            root.isCopied = true
                            resetTimer.restart()
                        }
                        if (plasmoid.formFactor === 2 || plasmoid.formFactor === 3) {
                            if (!plasmoid.configuration.isPinned) {
                                root.expanded = false
                            } else if (plasmoid.configuration.clearSearchOnCopy) {
                                searchField.clear()
                                root.searchQuery = ""
                            }
                        } else if (plasmoid.configuration.clearSearchOnCopy) {
                            searchField.clear()
                            root.searchQuery = ""
                        }

                        var originalIndex = snippetModel.snippets.findIndex(function(s) {
                            return s.title === snippet.title && s.text === snippet.text
                        })
                        if (originalIndex >= 0) {
                            if (plasmoid.configuration.sortByUsage) {
                                snippetModel.incrementUsage(originalIndex)
                            } else {
                                snippetModel.markAsUsed(originalIndex)
                            }
                        }
                    }
                }
            }
        }

        Connections {
            target: root
            function onExpandedChanged() {
                if (!root.expanded && !plasmoid.configuration.isPinned) {
                    snippetList.currentIndex = -1
                    snippetList.positionViewAtBeginning()
                    if (plasmoid.configuration.clearSearchOnCopy) {
                        searchField.clear()
                        root.searchQuery = ""
                    }
                }
            }
        }

        ToolBar {
            Layout.fillWidth: true
            implicitHeight: Kirigami.Units.iconSizes.medium + Kirigami.Units.largeSpacing
            position: ToolBar.Footer
            visible: plasmoid.configuration.showToolbarPanel

            RowLayout {
                anchors.fill: parent
                spacing: Kirigami.Units.smallSpacing

                Label {
                    Layout.leftMargin: Kirigami.Units.smallSpacing
                    text: i18np("%1 snippet", "%1 snippets", snippetModel.count)
                    opacity: 0.6
                }

                Item { Layout.fillWidth: true }

                Label {
                    text: i18n("Copied!")
                    opacity: root.isCopied ? 1 : 0
                    color: Kirigami.Theme.textColor

                    Behavior on opacity {
                        NumberAnimation { duration: Kirigami.Units.shortDuration }
                    }
                }

                ToolButton {
                    id: configButton
                    icon.name: "configure"
                    display: ToolButton.IconOnly
                    onClicked: plasmoid.internalAction("configure").trigger()
                    ToolTip.text: i18n("Configure")
                    ToolTip.visible: hovered
                    ToolTip.delay: Kirigami.Units.toolTipDelay
                    KeyNavigation.right: pinButton
                }

                ToolButton {
                    id: pinButton
                    icon.name: "window-pin"
                    display: ToolButton.IconOnly
                    checkable: true
                    checked: plasmoid.configuration.isPinned
                    down: checked
                    onToggled: plasmoid.configuration.isPinned = checked
                    ToolTip.text: i18n("Keep Open")
                    ToolTip.visible: hovered
                    ToolTip.delay: Kirigami.Units.toolTipDelay
                    KeyNavigation.left: configButton
                    visible: plasmoid.formFactor === 2 || plasmoid.formFactor === 3
                    enabled: visible
                }
            }
        }
    }
}