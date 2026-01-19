```bash
mkdir -p ~/.config/systemd/user/
nano ~/.config/systemd/user/syncthing.mount
```

```bash
[Unit]
Description=Mount syncthing folder via virtiofs

[Mount]
What=syncthing
Where=%h/syncthing
Type=virtiofs
Options=defaults

[Install]
WantedBy=default.target
```

```bash
# Recharger les unités utilisateur
systemctl --user daemon-reload

# Activer au démarrage (de votre session utilisateur)
systemctl --user enable syncthing.mount

# Démarrer maintenant
systemctl --user start syncthing.mount

# Vérifier le statut
systemctl --user status syncthing.mount
```