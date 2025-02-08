# Server Build Checklist with VirtualBox

## Host

### Server Configuration

- [x] (OPTIONAL) Upgrade to latest OS version (`sudo apt full-upgrade; do-release-upgrade`)
- [x] Install Updates
- [ ] Install unattended-upgrades package
- [x] Install curl (`sudo apt install curl`)
- [x] Enable SSH (`sudo apt install openssh-server`)
- [x] Install CIFS Utils (`sudo apt install cifs-utils`)
- [x] Copy .credentials_media to server
- [x] Add Plex repository ([reference](Repositories.md))
- [x] Create user/group media_manager (`sudo useradd --system --create-home --uid 666 --user-group media_manager`)
- [x] Add mounts ([reference](Plex&#32;Server/Mounts.md))
- [x] Install VirtualBox

### Plex

- [x] Install plexmediaserver (`sudo apt install plexmediaserver`)
- [x] Access and configure Plex server at <http://localhost:32400/web>
- [ ] Add Plex repository to unattended-upgrades ([reference](https://askubuntu.com/questions/87849/how-to-enable-silent-automatic-updates-for-any-repository))

### Post VM Configuration

- [ ] Set VM to autostart ([reference](https://kifarunix.com/autostart-virtualbox-vms-on-system-boot-on-linux/))

## Secure VM

### Server Configuration

- [x] Create Linux VM
- [x] Install VirtualBox Guest Additions
- [x] Install Updates
- [x] Install curl (`sudo apt install curl`)
- [x] Enable SSH (`sudo apt install openssh-server`)
- [x] Install CIFS Utils (`sudo apt install cifs-utils`)
- [x] Copy .credentials_media to server
- [x] Create user/group media_manager (`sudo useradd --system --create-home --uid 666 --user-group media_manager`)
- [x] Add NAS ("chimpanzee") to /etc/hosts file
- [x] Add mounts ([reference](Mounts.md))

### VPN

- [x] Install PIA VPN ([reference](https://www.privateinternetaccess.com/helpdesk/guides/linux/linux-installing-the-pia-app#linux-installing-the-pia-app_step-3-terminal))

### BitTorrent

- [x] Install qBittorrent
  - [x] Bind qBittorrent to VPN interface (e.g. tun0 or wgpia0)
  - [ ] Set qBittorrent to start automatically

### Jackett

- [x] Download Jackett (`wget --directory-prefix=Downloads https://github.com/Jackett/Jackett/releases/download/v0.19.108/Jackett.Binaries.LinuxAMDx64.tar.gz`)
- [x] Create jacket user/group (`sudo useradd --system --create-home --user-group jackett`)
- [x] Unzip TAR (`sudo tar -C /opt -xvzf Jackett.Binaries.LinuxAMDx64.tar.gz`)
- [x] Change ownership to jackett (`sudo chown -R jackett:jackett /opt/Jackett`)
- [x] Install as service (`sudo ./install_service_systemd.sh`)
  - [x] Go to admin page - <http://localhost:9117>
  - [x] Set base path override (`/home/jackett/downloads`)
  - [ ] (OPTIONAL) Set PIA socks5 proxy

### Sonarr

- [x] Install Mono (`sudo apt install mono-devel`)
- [x] Install Sonarr 3 entering "media_manager" as both the user and group when prompted ([reference](https://sonarr.tv/#downloads-v3-linux-ubuntu))
  - [x] Change owner of install to media_manager (`sudo chown -R media_manager:media_manager /opt/NzbDrone`)
  - [x] Create sonarr service ([reference](https://github.com/Sonarr/Sonarr/wiki/Autostart-on-Linux))
  - [ ] (OPTIONAL) Restore settings ([reference](https://github.com/Sonarr/Sonarr/wiki/Backup-and-Restore) | [backup](nzbdrone_backup_2019.12.27_14.38.28.zip))
  - [ ] Make sure restored files are owned by media_manager (`sudo chown media_manager:media_manager <file>`)

### Radarr

- [ ] Install Radarr ([reference](https://wiki.servarr.com/radarr/installation#debian-ubuntu-hands-on-install))
  - [ ] Create radarr service ([reference](https://www.smarthomebeginner.com/install-radarr-on-ubuntu/))
  - [ ] Start Radarr once
  - [ ] Restore settings ([backup](radarr_backup_2019.12.27_14.39.05.zip))
  - [ ] Make sure restored files are owned by media_manager (`sudo chown media_manager:media_manager <file>`)


cat << EOF | sudo tee /etc/systemd/system/radarr.service > /dev/null
[Unit]
Description=Radarr Daemon
After=syslog.target network.target
[Service]
User=media_manager
Group=media_manager
Type=simple

ExecStart=/opt/Radarr/Radarr -nobrowser -data=/var/lib/radarr/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF