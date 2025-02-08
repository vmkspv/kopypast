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

    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Kirigami.Units.largeSpacing
        }
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

        Item {
            Layout.fillHeight: true
        }
    }
}