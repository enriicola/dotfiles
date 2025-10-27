#!/usr/bin/env bash

set -euo pipefail

# Toggle between Pop!_OS light and dark appearances using gsettings.

color_key="org.gnome.desktop.interface"

current_scheme="$(gsettings get "${color_key}" color-scheme)"
current_scheme="${current_scheme//\'/}"

if [[ "${current_scheme}" == "prefer-dark" ]]; then
    new_scheme="prefer-light"
    gtk_theme="Pop"
    icon_theme="Pop"
    variant="light"
else
    new_scheme="prefer-dark"
    gtk_theme="Pop-dark"
    icon_theme="Pop"
    variant="dark"
fi

gsettings set "${color_key}" color-scheme "${new_scheme}"
gsettings set "${color_key}" gtk-theme "${gtk_theme}"
gsettings set "${color_key}" icon-theme "${icon_theme}"

printf 'Switched to %s appearance (scheme=%s, gtk=%s, icons=%s)\n' \
    "${variant}" "${new_scheme}" "${gtk_theme}" "${icon_theme}"
