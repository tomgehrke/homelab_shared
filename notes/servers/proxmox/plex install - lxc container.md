# Plex Install - LXC Container

- [ ] Create container using TurnKey Core template
  - [ ] Unprivileged = No
  - [ ] Features: Nesting, NFS
- [ ] Enable SSH via Webmin (https://<IP>:12321)
- [ ] `apt update && apt dist-upgrade`
- [ ] Add NFS mount for Plex media storage
  - [ ] `apt install nfs-common`
  - [ ] `mkdir /mnt/media`
  - [ ] Add the following to `/etc/fstab/`

    ```bash
    # NFS mount for Plex media
    192.168.0.200:/volume1/Media    /plexmedia      nfs     defaults        0       0
    ```

- [ ] Install plexmediaserver

    ```bash
    echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
    curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
    sudo apt update
    sudo apt install plexmediaserver
    ```

- [ ] Navigate to http://<IP>:32400
