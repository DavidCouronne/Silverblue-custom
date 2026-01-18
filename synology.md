# Créer un conteneur Debian

```bash
distrobox create --name debian --image debian:latest
```

# Entrer dans le conteneur
```bash
distrobox enter synology
```

# Dans le conteneur

```bash
wget "https://global.synologydownload.com/download/Utility/SynologyDriveClient/4.0.1-17885/Ubuntu/Installer/synology-drive-client-17885.x86_64.deb?model=DS214play&bays=2&dsm_version=7.1.1&build_number=42962" -O synology-drive.deb
```

```bash
sudo apt install ./synology-drive.deb
```

# Exporter l'application

```bash
distrobox-export --app synology-drive
```