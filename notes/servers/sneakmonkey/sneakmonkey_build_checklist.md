# Sneakmonkey Build Checklist

- [x] Provision VM (VirtualBox or Proxmox)
- [x] Disable IPv6
- [x] Apply Updates
- [x] Install necessary packages

  ```bash
  sudo apt install nfs-common docker docker-compose git qemu-guest-agent
  ```
- [x] Add user to docker group `sudo usermod -aG docker $USER`
- [x] Install Private Internet Access (https://www.privateinternataccess.com/download)
  - [x] Set to auto-start and auto-connect
- [x] Install homelab support (https://github.com/tomgehrke/homelab)
- [x] Create NFS mounts
  - [x] Add the following to /etc/fstab:

    ```bash
    # Docker mount
    192.168.100.200:/volume1/nfs_docker       /nfs_docker     nfs4    rw,noatime,rsize=8192,wsize=8192,tcp,timeo=14   0       0

    # Media mount
    192.168.100.200:/volume1/Media       /mnt/media     nfs4    rw,noatime,rsize=8192,wsize=8192,tcp,timeo=14   0       0
    ```

  - [x] Mount `sudo mount -a`
- [x] Install qBittorrent `sudo apt install qbittorrent`
  - [x] Bind qbittorrent to vpn interface (e.g. wgpia0)
- [ ] Install Sonarr
- [ ] Install Radarr
- [ ] Install Prowlarr
- [ ] Install Overseerr
- [ ] Install Bazaar
