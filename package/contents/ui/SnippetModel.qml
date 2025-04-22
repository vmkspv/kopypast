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
        const snippetsArray = snippets.slice()
        snippetsArray.push(item)
        updateModel(snippetsArray)
    }

    function set(index, item) {
        const snippetsArray = snippets.slice()
        snippetsArray[index] = item
        updateModel(snippetsArray)
    }

    function remove(index) {
        const snippetsArray = snippets.slice()
        snippetsArray.splice(index, 1)
        updateModel(snippetsArray)
    }

    function move(from, to) {
        if (from === to) return
        const snippetsArray = snippets.slice()
        snippetsArray.splice(to, 0, snippetsArray.splice(from, 1)[0])
        updateModel(snippetsArray)
    }

    function updateModel(newSnippets) {
        snippets = newSnippets
        configValue = JSON.stringify(newSnippets)
    }
}