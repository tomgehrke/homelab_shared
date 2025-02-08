# Disable IPv6

## Temporary

```bash
# On Ubuntu
sudo nano /etc/sysctl.conf

# Add the following:
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1

# Then...
sudo sysctl -p
```

## Permanent

```bash
sudo nano /etc/default/grub

# Append the following value
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"
GRUB_CMDLINE_LINUX="ipv6.disable=1"

# Then...
sudo update-grub
sudo reboot
```
