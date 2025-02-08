# Ubuntu Server Install on Proxmox

- [x] Download Ubuntu Server ISO (LTS) from Canonical
- [x] Upload ISO to Proxmox storage
- [x] Create VM
  - [x] Name VM
  - [x] Select ISO
  - [x] Guest OS = Linux
  - [x] Select Storage
  - [x] Select Cores (select all)
  - [x] Select RAM (set minimum)
  - [x] Select Network (default)
  - [x] Adjust memory ballooning (set maximum)
  - [x] Start VM
- [x] Configure VM
  - [x] Use Entire Disk
  - [x] Install OpenSSH
  - [x] Update Ubuntu
- [x] Install Guest Agent
  - [x] Enable QEMU Guest Agent under VM Options
  - [x] Install guest agent on VM `sudo apt install qemu-guest-agent`
  - [x] Shutdown/Restart
- [x] Enable automatic security updates
  - [x] Install unattended-upgrades `sudo apt install unattended-upgrades`
  - [x] Reconfigure unattended-upgrades `sudo dpkg-reconfigure --priority=low unattended-upgrades`
    - [x] Automatically download and install stable updates? Yes
  - [x] Check config `sudo nano /etc/apt/apt.conf.d/20auto-upgrades`
- [x] Disable root login `sudo passwd -l root`
- [x] Generate ssh key `ssh-keygen` and install `ssh-copy-id user@host`
- [ ] OPTIONAL: Disable password authentication to server
  - [ ] Edit config `sudo nano /etc/ssh/sshd_config`
  - [ ] Set `PasswordAuthentication no`
  - [ ] Set `ChallengeResponseAuthentication no`
- [ ] OPTIONAL: Install oh-my-posh
- [ ] OPTIONAL: Add NFS mounts
  - [ ] Install `nfs-common`
  - [ ] Create mount folder
  - [ ] Edit `/etc/fstab` to include something like the following:

  ```bash
  # NFS Mount for Docker volumes
  192.168.0.200:/volume1/nfs_volumes       /nfs_volumes     nfs    rw,noatime,rsize=8192,wsize=8192,tcp,timeo=14   0       0
  ```

  - [ ] If the Docker mount is for Synology hosted resources create a docker user that matches the UID of the owner on the NAS

  ```bash
  sudo useradd docker_user -u 1037 -g 100
  ```
