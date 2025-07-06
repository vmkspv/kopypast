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
            var parsedSnippets = JSON.parse(configValue || "[]")
            snippets = parsedSnippets.map(function(snippet) {
                return {
                    title: snippet.title,
                    text: snippet.text,
                    usageCount: snippet.usageCount || 0
                }
            })
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
        var snippetsArray = snippets.slice()
        snippetsArray.push(item)
        updateModel(snippetsArray)
    }

    function set(index, item) {
        var snippetsArray = snippets.slice()
        snippetsArray[index] = item
        updateModel(snippetsArray)
    }

    function remove(index) {
        var snippetsArray = snippets.slice()
        snippetsArray.splice(index, 1)
        updateModel(snippetsArray)
    }

    function move(from, to) {
        if (from === to) return
        var snippetsArray = snippets.slice()
        snippetsArray.splice(to, 0, snippetsArray.splice(from, 1)[0])
        updateModel(snippetsArray)
    }

    function incrementUsage(index) {
        var snippetsArray = snippets.slice()
        if (snippetsArray[index]) {
            snippetsArray[index].usageCount = (snippetsArray[index].usageCount || 0) + 1
            updateModel(snippetsArray)
        }
    }

    function getSortedSnippets(sortByUsage) {
        if (!sortByUsage) {
            return snippets
        }

        var sortedSnippets = snippets.slice()
        sortedSnippets.sort(function(a, b) {
            var usageA = a.usageCount || 0
            var usageB = b.usageCount || 0
            if (usageA !== usageB) {
                return usageB - usageA
            }
            var indexA = snippets.indexOf(a)
            var indexB = snippets.indexOf(b)
            return indexA - indexB
        })
        return sortedSnippets
    }

    function resetUsageCount() {
        var snippetsArray = snippets.slice()
        for (var i = 0; i < snippetsArray.length; i++) {
            snippetsArray[i].usageCount = 0
        }
        updateModel(snippetsArray)
    }

    function updateModel(newSnippets) {
        snippets = newSnippets
        configValue = JSON.stringify(newSnippets)
    }
}