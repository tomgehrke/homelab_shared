#!/bin/bash

setupDir="$(dirname "$(realpath "$0")")"

# Add sudoer
if [ -f "$setupDir/scripts/add-sudoer.sh" ] ; then
    "$setupDir/scripts/add-sudoer.sh"
fi

# Create soft link to bash_homelab
if [ -f "$setupDir/bash_homelab" ] ; then
    ln -sf "$setupDir/bash_homelab" ~/.bash_homelab
fi

# Install homelab CA cert
"$setupDir/certs/install-homelab_certificate_authority.sh"

# Add homelab script to .bashrc
bashBlock=$(cat <<EOF

# Tom's Homelab support
export HOMELAB="$setupDir"
if [ -f ~/.bash_homelab ]; then
  source ~/.bash_homelab
fi

EOF
)

echo "$bashBlock" >> ~/.bashrc

source ~/.bashrc
