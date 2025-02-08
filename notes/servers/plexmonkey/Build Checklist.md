# Plexmonkey Build Checklist

## Configuration

- [x] (Optional) Disable Wifi
- [x] Disable IPv6 ([reference](https://itsfoss.com/disable-ipv6-ubuntu-linux/))
- [ ] Install packages using the following command:

```bash
sudo apt install curl cifs-utils unattended-upgrades openssh-server
```

- [x] Create user/group media_manager (`sudo useradd --system --uid 666 --user-group media_manager`)
- [x] Copy .credentials_media to server
- [x] Add mount(s)

```bash
# Add Media storage mount(s) to /etc/fstab
//chimpanzee/Media /mnt/Media cifs credentials=/home/monkeyking/.credentials_media,vers=3.0,iocharset=utf8,sec=ntlmv2,cache=none,uid=666,gid=666,dir_mode=0777,file_mode=0777 0 0
```

## Plex

- [x] Install plexmediaserver

```bash
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt install plexmediaserver
```

- [x] Access and configure Plex server at <http://localhost:32400/web>
- [x] Add Plex repository to unattended-upgrades ([reference](https://askubuntu.com/questions/87849/how-to-enable-silent-automatic-updates-for-any-repository))

## Sonarr

- [x] Install Mono (`sudo apt install mono-devel`)
- [x] Install Sonarr ([reference](https://github.com/Sonarr/Sonarr/wiki/Installation#linux))
  - [x] Create sonarr service ([reference](https://github.com/Sonarr/Sonarr/wiki/Autostart-on-Linux))
  - [x] Start Sonarr once (`mono --debug /opt/NzbDrone/NzbDrone.exe`)
  - [x] Restore settings ([reference](https://github.com/Sonarr/Sonarr/wiki/Backup-and-Restore) | [backup](nzbdrone_backup_2019.12.27_14.38.28.zip))
  - [x] Make sure restored files are owned by media_manager (`sudo chown media_manager:media_manager <file>`)

## Radarr

- [x] Install Radarr ([reference](https://www.htpcguides.com/install-radarr-on-debian-8-jessie/))
  - [x] Create radarr service ([reference](https://www.smarthomebeginner.com/install-radarr-on-ubuntu/))
  - [x] Start Radarr once
  - [x] Restore settings ([backup](radarr_backup_2019.12.27_14.39.05.zip))
  - [x] Make sure restored files are owned by media_manager (`sudo chown media_manager:media_manager <file>`)

## VPN

- [x] Install OpenVPN (`sudo apt install openvpn`)
- [x] Download PIA profiles (`cd /etc/openvpn; sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip`)
- [x] Create VPN autostart service ([reference](https://www.htpcguides.com/autoconnect-private-internet-access-vpn-boot-linux/))

## BitTorrent

- [x] Install qBittorrent-nox
  - [x] Create qbittorrent-nox service ([reference](https://www.linuxbabe.com/ubuntu/install-qbittorrent-ubuntu-18-04-desktop-server))
  - [x] Bind qBittorrent to VPN interface (e.g. tun0)
  - [x] Restore settings ([backup](qBittorrent.conf))

## Jackett

- [x] Download Jackett ([release](https://github.com/Jackett/Jackett/releases/download/v0.12.1099/Jackett.Binaries.LinuxAMDx64.tar.gz))
- [x] Create jacket user/group (`sudo adduser --system --group jackett`)
- [x] Unzip TAR (`sudo tar -C /opt -xvzf Jackett.Binaries.LinuxAMDx64.tar.gz`)
- [x] Install as service ([reference](vf75ec3ldf0b2sw5rkr54atyg2npxmj2))
  - [x] Set manual download folder (`/home/jackett/downloads`)
  - [x] Set PIA socks5 proxy
