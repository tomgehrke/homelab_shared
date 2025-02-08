# Proxmox 7.2 Install

## Troubleshooting

### "Black Screen" during installation

Followed [this blog's](https://robertoviola.cloud/2020/04/16/proxmox-no-screen-during-installation/) instructions.

## Checklist

- [x] Install Proxmox
  - [x] Provision primary drive as BTRFS
  - [x] Assign static IP address and update documentation
- [x] Post-Install Configuration via SSH
  - [x] Modify `.bashrc` to enable aliases, etc.
  - [x] Configure Updates
    - [x] Update `/etc/apt/sources.list` by adding the following:

      ```bash
      # PVE pve-no-subscription repository provided by proxmox.com,
      # NOT recommended for production use
      deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
      ```

    - [x] Comment out the only line in `/etc/apt/sources.list.d/pve-enterprise.list`
    - [x] Apply updates - `apt update && apt dist-upgrade`
  - [x] Configure host hardware passthrough
    - [x] Comment and add following line to `/etc/default/grub`

      ```bash
      #GRUB_CMDLINE_LINUX_DEFAULT="quiet"
      GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"
      ```

    - [x] Run `udpate-grub`
    - [x] Add the following lines to `/etc/modules`

      ```bash
      vfio
      vfio_iommu_type1
      vfio_pci
      vfio_virqfd
      ```

    - [x] Reboot

- [ ] Post-Install Configuration via web UI (https://<ip>:8006)
  - [x] VLAN enable vmbr0 via Datacenter => Node => System => Network
  - [x] Add additional DNS servers via Datacenter => Node => System => DNS
  - [x] Add NFS mounts to Datacenter => Storage
    - [x] Make sure new node has been added to NFS security
    - [x] pveStorage on 192.168.0.200 (chimpanzee)
    - [x] pveBackup on 192.168.0.200 (chimpanzee)
- [ ] Join Cluster

## References

* Send Email Notifications - https://forum.proxmox.com/threads/get-postfix-to-send-notifications-email-externally.59940/
