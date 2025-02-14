# Stealthmonkey Build Checklist

- [ ] Provision VM (VirtualBox or Proxmox)
- [ ] Disable IPv6
- [ ] Apply Updates
- [ ] Install necessary packages `sudo apt install curl cifs-utils unattended-upgrades openssh-server`
  - [ ] If Proxmox VM install the guest agent and reboot `sudo apt install qemu-guest-agent`
- [ ] Install Private Internet Access
  - [ ] Set to auto-start and auto-connect
- [ ] Create Plex media mount
  - [ ] Create ~/.credentials_media file with username and password for media share
  - [ ] Add the following to /etc/fstab: `//192.168.86.3/Media /mnt/media cifs credentials=/home/monkeyking/.credentials_media,vers=3.0,iocharset=utf8,sec=ntlmv2,cache=none,uid=666,gid=666,dir_mode=0777,file_mode=0777 0 0`
  - [ ] Change uid and gid to match current user
  - [ ] Mount `sudo mount -a`
- [ ] Install qBittorrent
  - [ ] Add repository `sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable`
  - [ ] `sudo apt update`
  - [ ] `sudo apt install qbittorrent`
  - [ ] Bind qbittorrent to vpn interface (e.g. wgpia0)
- [ ] Install Jackett
  - [ ] Download latest release from [https://github.com/Jackett/Jackett/releases](https://github.com/Jackett/Jackett/releases)
  - [ ] Extract tar `sudo tar -C /opt -xvzf Jackett.Binaries.LinuxAMDx64.tar.gz`
  - [ ] Check ownership of /opt/Jackett `sudo chown -R monkeyking:monkeyking /opt/Jackett`
  - [ ] Install as service by running `sudo ./install_service_systemd.sh`
- [ ] Install Sonarr
  - [ ] Installation instructions can be found [here](https://sonarr.tv/)
- [ ] Install Radarr
