# Silverblue-custom

## Base

```bash
curl -sL https://raw.githubusercontent.com/DavidCouronne/Silverblue-custom/main/base.sh | bash
```

```bash
curl -sL https://raw.githubusercontent.com/DavidCouronne/Silverblue-custom/main/install.sh | bash
```

```bash
curl -sL https://raw.githubusercontent.com/DavidCouronne/Silverblue-custom/main/post-install.sh | bash
```

## Brave

```bash
curl -sL https://raw.githubusercontent.com/DavidCouronne/Silverblue-custom/main/brave.sh | bash
```


## rclone

```bash
rclone -n
````

```bash
wget https://raw.githubusercontent.com/DavidCouronne/Silverblue-custom/main/rclone-synology.service
```

```bash
nano ...
```

```
cp ./rclone-synology.service ~/.config/systemd/user/rclone-synology.service
```

```bash
systemctl --user enable --now rclone-synology.service
```


