/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Dialog {
    id: dialog
    parent: snippetsPage

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)

    title: editIndex === -1 ? i18n("Add Snippet") : i18n("Edit Snippet")
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    property bool isValid: titleField.text !== "" && textArea.text !== ""

    Component.onCompleted: {
        standardButton(Dialog.Ok).enabled = isValid
    }

    onIsValidChanged: {
        standardButton(Dialog.Ok).enabled = isValid
    }

    property int editIndex: -1
    property alias titleText: titleField.text
    property alias snippetText: textArea.text

    function createSnippet() {
        editIndex = -1
        titleText = ""
        snippetText = ""
        open()
    }

    function editSnippet(index) {
        editIndex = index
        let item = snippetModel.get(index)
        titleText = item.title
        snippetText = item.text
        open()
    }

    onAccepted: {
        if (editIndex === -1) {
            snippetModel.append({
                title: titleText,
                text: snippetText
            })
        } else {
            snippetModel.set(editIndex, {
                title: titleText,
                text: snippetText
            })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        PlasmaComponents.TextField {
            id: titleField
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.smallSpacing
            placeholderText: i18n("Snippet Title")
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: Kirigami.Units.smallSpacing

            PlasmaComponents.TextArea {
                id: textArea
                width: parent.width
                placeholderText: i18n("Snippet Text")
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.PlainText
            }
        }
    }
}