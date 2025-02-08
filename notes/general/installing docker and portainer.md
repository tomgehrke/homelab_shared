# Installing Docker & Portainer

## Base VM

- [ ] Provision VM. (see Ubuntu Server Install)
- [ ] Update via SSH
- [ ] Install Docker (if it's not already)
  - [ ] Run the following:

    ```bash
    # Pre-requisites may already be installed
    sudo apt install ca-certificates curl gnupg lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl enable --now docker

    # Optional if not running as root
    
    
    ```

  - [ ] Restart

- [ ] Install `docker-compose` (if it's not already)
  - [ ] Run the following:

    ```bash
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    ```

- [ ] Add shared docker storage
  - [ ] Make sure `nfs_docker` is installed
  - [ ] Create mount folder
  - [ ] Edit `/etc/fstab` to include something like the following:

  ```bash
  # NFS Mount for Docker volumes
  192.168.0.200:/volume1/nfs_volumes       /nfs_volumes     nfs    rw,noatime,rsize=8192,wsize=8192,tcp,timeo=14   0       0
  ```

  - [ ] If the Docker mount is for Synology hosted resources create a docker user that matches the UID of the owner on the NAS

  ```bash
  sudo useradd docker_user -u 1037 -g 100
  sudo usermod -aG docker docker_user
  ```

- [ ] Run `mount -a` to make sure it's working
- [ ] Restart

## Portainer Installation

### Standalone Docker

#### Server

- [ ] Run the following:

  - [ ] Either...

  ```bash
  docker run -d \
    -p 8000:8000 \
    -p 9443:9443 \
    --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /portainer/data:/data \
    portainer/portainer-ce:latest
  ```

  - [ ] ...or create a `docker-compose.yml` and execute `docker-compose up -d` in the same folder

  ```text
  version: '3'

  services:
    portainer:
      image: portainer/portainer-ce:latest
      container_name: portainer
      restart: unless-stopped
      security_opt:
        - no-new-privileges:true
      volumes:
        - /etc/localtime:/etc/localtime:ro
        - /var/run/docker.sock:/var/run/docker.sock:ro
        - /portainer/data/:/data
      ports:
        - 8000:8000
        - 9443:9443
    ```

#### Agent

- [ ] Run the following:

  ```bash
  docker run -d -p 9001:9001 --name portainer_agent \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    portainer/agent:latest
  ```

### Docker Swarm

- [ ] Pick primary VM/CT and run the following:

    ```bash
    docker swarm init --advertise-addr <IP ADDRESS>
    ```

- [ ] Copy the "docker swarm join" command line that is provided and run that on each of the other docker containers
- [ ] Install Portainer
  - [ ] Create persistent volume at `/docker_shared/portainer/data`
  - [ ] Run the following:

    ```bash
    # Grab the default manifest
    curl -L https://downloads.portainer.io/ce2-14/portainer-agent-stack.yml -o portainer-agent-stack.yml

    # Modify the manifest to point to shared storage
    nano portainer-agent-stack.yml

    #Deploy stack
    docker stack deploy -c portainer-agent-stack.yml portainer
    ```

  - [ ] Navigate to `https://<server IP>:9443` and create admin account
