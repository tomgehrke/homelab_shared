# Setting up email on Proxmox hosts

- [ ] Change /etc/postfix/main.cf to include/change these lines:

    ```text
    relayhost = [smtp.gmail.com]:587
    smtp_use_tls = yes
    smtp_sasl_auth_enable = yes
    smtp_sasl_security_options = noanonymous
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
    smtp_header_checks = pcre:/etc/postfix/smtp_header_checks
    ```

- [ ] Create `/etc/postfix/sasl_passwd`

    ```text
    [smtp.gmail.com]:587    testmehere@gmail.com:PASSWD
    ```

- [ ] Create `/etc/postfix/smtp_header_checks`

    ```text
    /^From:.*/ REPLACE From: HOSTNAME-alert <HOSTNAME-alert@something.com>
    ```

- [ ] Execute the following:

    ```bash
    apt-get install libsasl2-modules postfix-pcre
    chmod 600 /etc/postfix/sasl_passwd
    postmap /etc/postfix/sasl_passwd
    systemctl restart postfix.service
    ```

- [ ] Test

    ```bash
    echo "Test mail from postfix" | mail -s "Test Postfix" test@test.com
    ```
