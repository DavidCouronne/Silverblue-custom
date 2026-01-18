#!/usr/bin/bash

# Interrompre en cas d'erreur
set -euo pipefail

echo "=== Configuration personnalisée Silverblue ==="

rpm-ostree install calibre distrobox rclone cockpit

echo "=== Configuration Gnome extensionsions ==="

rpm-ostree install gnome-shell-extension-dash-to-dock gnome-tweaks

echo "=== Installation de Brave ==="

sudo tee /etc/yum.repos.d/brave-browser-rpm-release.repo <<EOF
[brave-browser-rpm-release]
name=Brave Browser Release
baseurl=https://brave-browser-rpm-release.s3.brave.com/x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
EOF


rpm-ostree install brave-browser