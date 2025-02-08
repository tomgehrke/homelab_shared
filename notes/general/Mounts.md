# Plex Server Mounts

Add the following to `/etc/fstab`.

> **Note:** Update the Plex Mount uid/gid to reference the plex uid/gid that were created after the installation of the Plex Media Server.
>
> Also make sure the path to .credentials_media is correct.

```bash
# Plex Storage Mounts
# //chimpanzee/UHD /mnt/UHD cifs credentials=/home/monkeyking/.credentials_media,vers=3.0,iocharset=utf8,sec=ntlmv2,cache=none,uid=122,gid=128,dir_mode=0777,file_mode=0777 0 0
//chimpanzee/Media /mnt/Media cifs credentials=/home/monkeyking/.credentials_media,vers=3.0,iocharset=utf8,sec=ntlmv2,cache=none,uid=666,gid=666,dir_mode=0777,file_mode=0777 0 0
```

Execute:

```bash
sudo mount --all
```
