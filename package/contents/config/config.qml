/*
    SPDX-FileCopyrightText: 2025 Vladimir Kosolapov
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Snippets")
        icon: Qt.resolvedUrl("../icons/io.github.vmkspv.kopypast.svg")
        source: "configSnippets.qml"
    }
}