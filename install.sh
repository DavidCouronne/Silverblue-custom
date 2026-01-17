#!/usr/bin/bash

# Interrompre en cas d'erreur
set -euo pipefail

echo "=== Configuration personnalisée Silverblue ==="

# --- 1. Gestion des dépôts tiers (Brave) ---
echo "Vérification du dépôt Brave..."
if [ ! -f /etc/yum.repos.d/brave-browser-rpm-release.repo ]; then
    echo "Ajout du dépôt Brave Browser..."
    # On crée le fichier repo manuellement
    sudo tee /etc/yum.repos.d/brave-browser-rpm-release.repo <<EOF
[brave-browser-rpm-release]
name=Brave Browser Release
baseurl=https://brave-browser-rpm-release.s3.brave.com/x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
EOF
    echo "Dépôt ajouté avec succès."
else
    echo "Dépôt Brave déjà présent."
fi

# --- 2. Installation / Suppression de paquets (Layering & Overrides) ---
# Liste des paquets à ajouter
PACKAGES=(
    distrobox
    cargo
    cifs-utils
    gnome-shell-extension-dash-to-dock
    gnome-tweaks
    brave-browser
    syncthing
    cockpit
)

TO_INSTALL=()

echo "Vérification des paquets système..."
for pkg in "${PACKAGES[@]}"; do
    if ! rpm-ostree status | grep -q "$pkg"; then
        TO_INSTALL+=("$pkg")
    fi
done

# Vérification si Firefox doit être supprimé
# On vérifie s'il est présent dans l'image de base et pas encore supprimé
SHOULD_REMOVE_FIREFOX=false
if rpm-ostree status | grep -q "firefox" && ! rpm-ostree status | grep -q "●.*-firefox"; then
    SHOULD_REMOVE_FIREFOX=true
fi

# Application des changements rpm-ostree
if [ ${#TO_INSTALL[@]} -ne 0 ] || [ "$SHOULD_REMOVE_FIREFOX" = true ]; then
    COMMAND="rpm-ostree update" # On prépare la commande
    
    if [ ${#TO_INSTALL[@]} -ne 0 ]; then
        echo "Installation des paquets : ${TO_INSTALL[*]}"
        COMMAND="$COMMAND --install ${TO_INSTALL[*]}"
    fi
    
    if [ "$SHOULD_REMOVE_FIREFOX" = true ]; then
        echo "Suppression de Firefox (override remove)..."
        COMMAND="$COMMAND --override remove firefox"
    fi
    
    sudo $COMMAND
else
    echo "Aucune modification système (installation/suppression) nécessaire."
fi

# --- 3. Activation de Dash to Dock ---
EXTENSION_ID="dash-to-dock@micxgx.gmail.com"
CURRENT_EXTENSIONS=$(gsettings get org.gnome.shell enabled-extensions)

if [[ "$CURRENT_EXTENSIONS" != *"$EXTENSION_ID"* ]]; then
    echo "Activation de l'extension Dash to Dock..."
    if [[ "$CURRENT_EXTENSIONS" == "@as []" ]] || [[ "$CURRENT_EXTENSIONS" == "[]" ]]; then
        gsettings set org.gnome.shell enabled-extensions "['$EXTENSION_ID']"
    else
        NEW_EXTENSIONS=$(echo "$CURRENT_EXTENSIONS" | sed "s/\]/,'$EXTENSION_ID'\]/")
        gsettings set org.gnome.shell enabled-extensions "$NEW_EXTENSIONS"
    fi
fi

# --- 4. Configuration des mises à jour automatiques ---
if ! grep -q "AutomaticUpdatePolicy=stage" /etc/rpm-ostreed.conf; then
    echo "Configuration de la mise à jour automatique (stage)..."
    sudo sed -i 's/AutomaticUpdatePolicy=none/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf
    sudo systemctl enable --now rpm-ostreed-automatic.timer
fi

echo "=== Script terminé ==="
echo "Note : Un redémarrage est nécessaire pour appliquer les changements (Brave, suppression Firefox)."