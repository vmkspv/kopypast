/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
    property int editIndex: -1
    property alias titleText: titleField.text
    property alias snippetText: textArea.text

    Component.onCompleted: {
        standardButton(Dialog.Ok).enabled = isValid
    }

    onIsValidChanged: {
        standardButton(Dialog.Ok).enabled = isValid
    }

    onOpened: titleField.forceActiveFocus()

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

        TextField {
            id: titleField
            Layout.fillWidth: true
            placeholderText: i18n("Snippet Title")
            onAccepted: textArea.forceActiveFocus()
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.bottomMargin: Kirigami.Units.smallSpacing

            TextArea {
                id: textArea
                width: parent.width
                placeholderText: i18n("Snippet Text")
                wrapMode: TextEdit.Wrap
                textFormat: TextEdit.PlainText
            }
        }

        Button {
            icon.name: "code-context"
            text: i18n("Available Variables")
            flat: true
            hoverEnabled: false
            Layout.leftMargin: -Kirigami.Units.smallSpacing
            visible: plasmoid.configuration.handleVariables

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.WhatsThisCursor
                onEntered: toolTip.visible = true
                onExited: toolTip.visible = false
            }

            ToolTip {
                id: toolTip
                delay: Kirigami.Units.toolTipDelay
                timeout: -1

                contentItem: GridLayout {
                    columns: 2
                    columnSpacing: Kirigami.Units.largeSpacing
                    rowSpacing: Kirigami.Units.smallSpacing

                    Label { text: "{DATE}"; font.family: "monospace" }
                    Label { text: i18n("current date in local format"); opacity: 0.7 }

                    Label { text: "{TIME}"; font.family: "monospace" }
                    Label { text: i18n("current time in local format"); opacity: 0.7 }

                    Label { text: "{DATETIME}"; font.family: "monospace" }
                    Label { text: i18n("current date and time"); opacity: 0.7 }

                    Label { text: "{ISO_DATE}"; font.family: "monospace" }
                    Label { text: i18n("date in YYYY-MM-DD format"); opacity: 0.7 }

                    Label { text: "{ISO_TIME}"; font.family: "monospace" }
                    Label { text: i18n("time in HH:mm:ss format"); opacity: 0.7 }

                    Label { text: "{ISO_DATETIME}"; font.family: "monospace" }
                    Label { text: i18n("full ISO date and time"); opacity: 0.7 }

                    Label { text: "{YEAR}"; font.family: "monospace" }
                    Label { text: i18n("current year (4 digits)"); opacity: 0.7 }

                    Label { text: "{MONTH}"; font.family: "monospace" }
                    Label { text: i18n("current month (01-12)"); opacity: 0.7 }

                    Label { text: "{DAY}"; font.family: "monospace" }
                    Label { text: i18n("current day (01-31)"); opacity: 0.7 }

                    Label { text: "{HOUR}"; font.family: "monospace" }
                    Label { text: i18n("current hour (00-23)"); opacity: 0.7 }

                    Label { text: "{MINUTE}"; font.family: "monospace" }
                    Label { text: i18n("current minute (00-59)"); opacity: 0.7 }

                    Label { text: "{SECOND}"; font.family: "monospace" }
                    Label { text: i18n("current second (00-59)"); opacity: 0.7 }
                }
            }
        }
    }
}