#!/usr/bin/bash

# Interrompre en cas d'erreur
set -euo pipefail

echo "=== Configuration personnalisée Silverblue ==="

# --- 1. Installation des paquets système (Layering) ---
# On liste les paquets à installer
PACKAGES=(distrobox gnome-shell-extension-dash-to-dock gnome-tweaks)
TO_INSTALL=()

echo "Vérification des paquets système..."
for pkg in "${PACKAGES[@]}"; do
    # On vérifie si le paquet est déjà installé via rpm-ostree
    if ! rpm-ostree status | grep -q "$pkg"; then
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -ne 0 ]; then
    echo "Installation des paquets suivants : ${TO_INSTALL[*]}"
    sudo rpm-ostree install -y "${TO_INSTALL[@]}"
else
    echo "Tous les paquets système sont déjà installés."
fi

# --- 2. Activation de Dash to Dock ---
# L'ID de l'extension pour Fedora
EXTENSION_ID="dash-to-dock@micxgx.gmail.com"

echo "Configuration de l'extension Dash to Dock..."
# On récupère la liste actuelle des extensions activées
CURRENT_EXTENSIONS=$(gsettings get org.gnome.shell enabled-extensions)

if [[ "$CURRENT_EXTENSIONS" != *"$EXTENSION_ID"* ]]; then
    echo "Activation de l'extension..."
    # On ajoute l'extension à la liste sans écraser les autres
    # Si la liste est vide ou '@as []', on initialise proprement
    if [[ "$CURRENT_EXTENSIONS" == "@as []" ]] || [[ "$CURRENT_EXTENSIONS" == "[]" ]]; then
        gsettings set org.gnome.shell enabled-extensions "['$EXTENSION_ID']"
    else
        # On insère l'ID dans la liste existante
        NEW_EXTENSIONS=$(echo "$CURRENT_EXTENSIONS" | sed "s/\]/,'$EXTENSION_ID'\]/")
        gsettings set org.gnome.shell enabled-extensions "$NEW_EXTENSIONS"
    fi
else
    echo "L'extension Dash to Dock est déjà activée."
fi


echo "=== Script terminé ==="
echo "Note : Un redémarrage est nécessaire pour voir Dash to Dock et Tweaks."