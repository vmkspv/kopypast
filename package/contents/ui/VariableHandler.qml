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
            "{DATE}"           : Qt.formatDate(now, Qt.LocaleDate),
            "{TIME}"           : Qt.formatTime(now, Qt.LocaleTime),
            "{DATETIME}"       : Qt.formatDateTime(now, Qt.DefaultLocaleShortDate),
            "{ISO_DATE}"       : Qt.formatDate(now, "yyyy-MM-dd"),
            "{ISO_TIME}"       : Qt.formatTime(now, "HH:mm:ss"),
            "{ISO_TIME_DASHED}": Qt.formatTime(now, "HH-mm-ss"),
            "{ISO_DATETIME}"   : Qt.formatDateTime(now, "yyyy-MM-dd HH:mm:ss"),
            "{YEAR}"           : Qt.formatDate(now, "yyyy"),
            "{MONTH}"          : Qt.formatDate(now, "MM"),
            "{DAY}"            : Qt.formatDate(now, "dd"),
            "{HOUR}"           : Qt.formatTime(now, "HH"),
            "{HOUR12}"         : ((now.getHours() % 12) || 12).toString().padStart(2, '0'),
            "{MINUTE}"         : Qt.formatTime(now, "mm"),
            "{SECOND}"         : Qt.formatTime(now, "ss"),
            "{AMPM}"           : Qt.formatTime(now, "AP")
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