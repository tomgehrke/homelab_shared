# Install everything we want on our VMs
sudo apt install qemu-guest-agent unattended-upgrades nfs-common

# Make sure unattended-upgrades is enabled
sudo dpkg-reconfigure --priority=low unattended-upgrades
