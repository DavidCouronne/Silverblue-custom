```bash
# Créer un toolbox Fedora
toolbox create synology-build
```

# Entrer dans le toolbox

```bash
toolbox enter synology-build
```

# Installer les outils de build

```bash
sudo dnf install rpm-build rpmdevtools binutils
```

```bash
rpmdev-setuptree
```

# Télécharger le .deb dans ~/rpmbuild/SOURCES/

```bash
mkdir -p ~/rpmbuild/SOURCES/
cd ~/rpmbuild/SOURCES/
wget "https://global.synologydownload.com/download/Utility/SynologyDriveClient/4.0.1-17885/Ubuntu/Installer/synology-drive-client-17885.x86_64.deb"
```

# Copier le spec file dans ~/rpmbuild/SPECS/

```bash
mkdir -p ~/rpmbuild/SOURCES/
cd ~/rpmbuild/SPECS/
wget "https://raw.githubusercontent.com/DavidCouronne/Silverblue-custom/main/synology-drive.spec"
```

```bash
mkdir -p ~/rpmbuild/SPECS/
cd ~/rpmbuild/SPECS/
rpmbuild -bb synology-drive.spec
```


# Copier le RPM sur le système hôte

```bash
cp ~/rpmbuild/RPMS/x86_64/synology-drive-4.0.1-17885.*.rpm /tmp/
```

# Sortir de la distrobox et installer sur l'hôte

```bash
exit
```

# Sur Silverblue

```bash
rpm-ostree install /tmp/synology-drive-4.0.1-17885.*.rpm
systemctl reboot
```



