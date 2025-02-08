# Create Wildcard Certificate (Let's Encrypt)

- [ ] Install *python3* and *certbot*

    ```bash
    sudo apt update
    sudo apt install python3 certbot
    ```

- [ ] Request wildcard Certificate

    ```bash
    sudo certbot certonly --manual --preferred-challenge=dns --email tomgehrke@gmail.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos --manual-public-ip-logging-ok -d "*.domain.com"
    ```
