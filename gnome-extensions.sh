#!/usr/bin/bash

# Interrompre en cas d'erreur
set -euo pipefail

echo "=== Configuration Gnome extensionsions ==="

rpm-ostree --install gnome-shell-extension-dash-to-dock gnome-tweaks