#!/usr/bin/bash

# Interrompre en cas d'erreur
set -euo pipefail

echo "=== Configuration personnalisée Silverblue ==="

# --- 1. Installation de Distrobox ---
echo "Vérification de Distrobox..."

# On vérifie si distrobox est déjà dans le PATH
if ! command -v distrobox &> /dev/null; then
    echo "Distrobox n'est pas installé. Ajout à la couche système..."
    # rpm-ostree gère très bien l'idempotence, mais vérifier avant 
    # permet d'économiser du temps de calcul sur les métadonnées.
    sudo rpm-ostree install -y distrobox
else
    echo "Distrobox est déjà installé. Passage à la suite."
fi

echo "=== Script terminé ==="
echo "Note : Si des paquets ont été installés, un redémarrage est nécessaire."