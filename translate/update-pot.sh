#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;94m'
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m'

print_step() { echo -e "${BLUE}[*]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${GRAY}[i]${NC} $1"; }

cd "$(dirname "$0")/.."

namespace="io.github.vmkspv.kopypast"

print_step "Extracting translatable strings..."
xgettext --from-code=UTF-8 \
         --output=translate/kopypast.pot \
         --package-name=Kopypast \
         --copyright-holder="Vladimir Kosolapov" \
         --msgid-bugs-address="https://github.com/vmkspv/kopypast/issues" \
         --add-location=file \
         --keyword=i18n:1 \
         --keyword=i18nc:1c,2 \
         --keyword=i18np:1,2 \
         --keyword=i18ncp:1c,2,3 \
         --keyword=ki18n:1 \
         --keyword=ki18nc:1c,2 \
         --keyword=ki18np:1,2 \
         --keyword=ki18ncp:1c,2,3 \
         package/contents/**/*.qml \
         2>/dev/null

print_step "Updating POT creation date..."
sed -i 's/^"POT-Creation-Date:.*/"POT-Creation-Date: '"$(date +'%Y-%m-%d %H:%M%z')"'\\n"/' translate/kopypast.pot

print_success "kopypast.pot updated successfully."

print_step "Compiling translation files..."
compiled_count=0

for po_file in translate/*.po; do
    if [ -f "$po_file" ]; then
        lang=$(basename "$po_file" .po)
        locale_dir="package/contents/locale/$lang/LC_MESSAGES"
        mkdir -p "$locale_dir"

        msgfmt -o "$locale_dir/plasma_applet_$namespace.mo" "$po_file" 2>/dev/null

        if [ $? -eq 0 ]; then
            ((compiled_count++))
        else
            print_error "Failed to compile $lang translation!"
        fi
    fi
done

print_success "Translations processing completed."

print_info "Total translatable strings: $(grep -c msgid translate/kopypast.pot)"
print_info "Total compiled translations: $compiled_count"