/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick

QtObject {
    function processVariables(text) {
        if (!plasmoid.configuration.handleVariables) {
            return text
        }

        var now = new Date()

        var replacements = {
            "{DATE}": Qt.formatDate(now, Qt.LocaleDate),
            "{TIME}": Qt.formatTime(now, Qt.LocaleTime),
            "{DATETIME}": Qt.formatDateTime(now, Qt.DefaultLocaleShortDate),
            "{ISO_DATE}": now.toISOString().split('T')[0],
            "{ISO_TIME}": now.toISOString().split('T')[1].split('.')[0],
            "{ISO_DATETIME}": now.toISOString().replace('T', ' ').split('.')[0],
            "{YEAR}": now.getFullYear().toString(),
            "{MONTH}": (now.getMonth() + 1).toString().padStart(2, '0'),
            "{DAY}": now.getDate().toString().padStart(2, '0'),
            "{HOUR}": now.getHours().toString().padStart(2, '0'),
            "{MINUTE}": now.getMinutes().toString().padStart(2, '0'),
            "{SECOND}": now.getSeconds().toString().padStart(2, '0')
        }

        var result = text
        for (var key in replacements) {
            if (replacements.hasOwnProperty(key)) {
                var value = replacements[key]
                result = result.replace(new RegExp(key, 'g'), value)
            }
        }
        return result
    }
}