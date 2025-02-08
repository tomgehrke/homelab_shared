# Portainer Install

- [ ] Install Docker [https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
- [x] Add account to docker group `sudo usermod -aG docker $USER`
- [x] Logout/Login
- [x] Try it `docker version`
- [x] Create portainer

docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    cr.portainer.io/portainer/portainer-ce:2.9.3