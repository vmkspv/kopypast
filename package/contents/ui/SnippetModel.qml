/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick

Item {
    id: snippetModel

    property string configValue: ""
    property var snippets: []
    property int count: snippets.length

    onConfigValueChanged: {
        try {
            snippets = JSON.parse(configValue || "[]")
        } catch (e) {
            console.error("Failed to parse snippets:", e)
            snippets = []
        }
    }

    function loadFromConfig(config) {
        configValue = config
    }

    function get(index) {
        return snippets[index]
    }

    function append(item) {
        snippets = [...snippets, item]
        configValue = JSON.stringify(snippets)
    }

    function set(index, item) {
        snippets = [...snippets.slice(0, index), item, ...snippets.slice(index + 1)]
        configValue = JSON.stringify(snippets)
    }

    function remove(index) {
        snippets = [...snippets.slice(0, index), ...snippets.slice(index + 1)]
        configValue = JSON.stringify(snippets)
    }
}