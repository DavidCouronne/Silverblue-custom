#!/usr/bin/bash

# Interrompre en cas d'erreur
set -euo pipefail

echo "=== ÉTAPE 2 : CONFIGURATION POST-INSTALLATION ==="

# --- 1. Configuration du Firewall ---
echo "Configuration du pare-feu (Firewalld)..."

# Cockpit : Port 9090
# Syncthing : Port 22000 (transfert) et 21027 (découverte locale)
SERVICES=(cockpit syncthing)

for svc in "${SERVICES[@]}"; do
    if ! sudo firewall-cmd --list-services | grep -q "$svc"; then
        echo "Ajout du service $svc au firewall..."
        sudo firewall-cmd --permanent --add-service="$svc"
    fi
done

# Rechargement pour appliquer les changements
sudo firewall-cmd --reload

# --- 2. Activation des Services Système (Root) ---
echo "Activation des services système..."

# On active le socket de Cockpit (il ne consomme des ressources que quand on se connecte)
sudo systemctl enable --now cockpit.socket

# --- 3. Activation des Services Utilisateur (User) ---
echo "Activation des services utilisateur..."

# Syncthing doit tourner pour ton utilisateur pour gérer tes fichiers
systemctl --user enable --now syncthing.service

# --- 4. Configuration GNOME (Extensions) ---
echo "Activation de l'extension Dash to Dock..."
EXTENSION_ID="dash-to-dock@micxgx.gmail.com"
CURRENT_EXTENSIONS=$(gsettings get org.gnome.shell enabled-extensions)

if [[ "$CURRENT_EXTENSIONS" != *"$EXTENSION_ID"* ]]; then
    if [[ "$CURRENT_EXTENSIONS" == "@as []" ]] || [[ "$CURRENT_EXTENSIONS" == "[]" ]]; then
        gsettings set org.gnome.shell enabled-extensions "['$EXTENSION_ID']"
    else
        NEW_EXTENSIONS=$(echo "$CURRENT_EXTENSIONS" | sed "s/\]/,'$EXTENSION_ID'\]/")
        gsettings set org.gnome.shell enabled-extensions "$NEW_EXTENSIONS"
    fi
    echo "Extension activée."
else
    echo "Extension déjà active."
fi

# --- 5. Rappel des accès ---
echo ""
echo "=== CONFIGURATION TERMINÉE ! ==="
echo "Accès Cockpit : https://localhost:9090 (ou l'IP de la VM)"
echo "Accès Syncthing : http://localhost:8384"
echo "--------------------------------------------------------"
echo "Prochaine étape : Installation de Rustic et Dufs (Rust)"