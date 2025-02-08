/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils
import org.kde.kirigami as Kirigami

SimpleKCM {
    property alias cfg_useSymbolicIcon: useSymbolicIcon.checked
    property alias cfg_showSearchField: showSearchField.checked
    property alias cfg_showToolbarPanel: showToolbarPanel.checked
    property alias cfg_showOnlyTitles: showOnlyTitles.checked
    property alias cfg_maxSnippets: maxSnippetsSpinner.value
    property alias cfg_useKbdNavigation: useKbdNavigation.checked

    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Kirigami.Units.largeSpacing
        }
        spacing: Kirigami.Units.gridUnit

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing * 2

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                Layout.minimumWidth: Kirigami.Units.gridUnit * 12
                Layout.maximumWidth: Kirigami.Units.gridUnit * 12
                Layout.fillHeight: true

                Label {
                    Layout.fillWidth: true
                    text: i18n("Appearance")
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Configure how the widget looks")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                CheckBox {
                    id: useSymbolicIcon
                    text: i18n("Monochrome icon")
                    Layout.fillWidth: true
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Use a monochrome icon that matches the color scheme")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                    leftPadding: useSymbolicIcon.indicator.width + useSymbolicIcon.spacing
                }

                CheckBox {
                    id: showSearchField
                    text: i18n("Enable search bar")
                    Layout.fillWidth: true
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Show a search field at the top of the widget")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                    leftPadding: showSearchField.indicator.width + showSearchField.spacing
                }

                CheckBox {
                    id: showToolbarPanel
                    text: i18n("Show bottom toolbar")
                    Layout.fillWidth: true
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Place a toolbar with counter and buttons at the bottom")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                    leftPadding: showToolbarPanel.indicator.width + showToolbarPanel.spacing
                }

                CheckBox {
                    id: showOnlyTitles
                    text: i18n("Hide snippet previews")
                    Layout.fillWidth: true
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Show only snippet titles without content previews")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                    leftPadding: showOnlyTitles.indicator.width + showOnlyTitles.spacing
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.largeSpacing
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing * 2

            ColumnLayout {
                Layout.alignment: Qt.AlignTop
                Layout.minimumWidth: Kirigami.Units.gridUnit * 12
                Layout.maximumWidth: Kirigami.Units.gridUnit * 12
                Layout.fillHeight: true

                Label {
                    Layout.fillWidth: true
                    text: i18n("Functionality")
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Configure behavior and limitations")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Label {
                        text: i18n("Maximum number of snippets:")
                        Layout.alignment: Qt.AlignVCenter
                    }

                    SpinBox {
                        id: maxSnippetsSpinner
                        from: 10
                        to: 100
                        stepSize: 5
                        Layout.alignment: Qt.AlignVCenter
                    }
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Limit the number of snippets for optimal performance")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                }

                CheckBox {
                    id: useKbdNavigation
                    text: i18n("Keyboard navigation")
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.smallSpacing
                }

                Label {
                    Layout.fillWidth: true
                    text: i18n("Use the keyboard keys to navigate and select snippets")
                    wrapMode: Text.WordWrap
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}