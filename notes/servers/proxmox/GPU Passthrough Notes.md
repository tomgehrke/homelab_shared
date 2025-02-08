GPU Passthrough Notes

On Host:

In /etc/default/grub replace line...
    GRUB_CMDLINE_LINUX_DEFAULT="quiet"

With...
    GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on pcie_acs_override=downstream,multifunction video=efifb:eek:ff"

Run update-grub

Reboot

In /etc/modules add the following lines...
    vfio
    vfio_iommu_type1
    vfio_pci
    vfio_virqfd

Reboot

Modify VM:

Add PCI Device

Add to /etc/pve/qemu-server/<ID>.conf...
    cpu: host,hidden=1,flags=+pcid

Start VM

Aside...
    sudo apt search nvidia-driver

Run...
    sudo apt install --no-install-recommends build-essential nvidia-headless-515-server
    sudo apt install --no-install-recommends build-essential nvidia-utils-515-server
    sudo apt install --no-install-recommends build-essential nvidia-cuda-toolkit
    sudo apt install --no-install-recommends build-essential libnvidia-encode-515-server

Reboot
