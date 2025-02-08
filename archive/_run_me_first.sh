# The Master script

# Update everything
sudo apt update
sudo apt upgrade

# Add VM-specific items
# ToDo: Prompt for whether this is a VM or not
prepare-vm.sh

# Set global git settings in case we want to push changes back to repo
setup-git.sh

# Disable IPv6 (hopefully)
disable-ipv6.sh

# Register with Netdata
add-netdata-node.sh

# Makeour prompt pretty
install-ohmyposh.sh
