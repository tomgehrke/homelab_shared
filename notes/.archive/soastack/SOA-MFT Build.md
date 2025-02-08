# Oracle SOA & MFT Server Build

## References

- [Oracle Linux 8 Installation Instructions](https://oracle-base.com/articles/linux/oracle-linux-8-installation)
- [Oracle Database 21c Installation on Oracle 8 Instructions](https://oracle-base.com/articles/21c/oracle-db-21c-installation-on-oracle-linux-8)
- [Oracle Universal Installer (OUI) Silent Installations](https://oracle-base.com/articles/misc/oui-silent-installations)
- [Quick Start for Oracle SOA Suite](https://docs.oracle.com/en/middleware/fusion-middleware/12.2.1.4/soaqs/installing-and-configuring-oracle-soa-suite-quick-start-developers.html)
- [Installing Oracle Managed File Transfer for Quick Start](https://docs.oracle.com/en/middleware/fusion-middleware/12.2.1.4/soaqs/adding-components-quick-start-installation1.html#GUID-0B650B2A-B64C-4F58-B225-2725BBB3A2EC)
- [Configurate a Compact Domain](https://docs.oracle.com/en/middleware/fusion-middleware/12.2.1.4/soaqs/BPM-COMPACT.html#GUID-79114282-39B6-4EBF-853F-73158636BAA2)
- [Creating Linux Services](https://oracle-base.com/articles/linux/linux-services-systemd#creating-linux-services)
- [Setup Gmail as mail provider for SOA Suite 12c](https://technology.amis.nl/soa/setup-gmail-as-mail-provider-for-soa-suite-12c-configure-smtp-certificate-in-trust-store/)
- [Using the DemoIdentity and DemoTrust keystores that come with weblogic](http://kingsfleet.blogspot.com/2008/11/using-demoidentity-and-demotrust.html)

## Server Install

- [x] Install OS
- [x] Configure OS
  - [x] Adjust SeLinux

    ```bash
    sudo nano /etc/selinux/config
    # Change SELINUX=permissive (or disabled)
    ```

  - [x] Disable Firewall

    ```bash
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    ```

  - [x] Enable SSH

    ```bash
    sudo systemctl start sshd.service
    sudo systemctl enable sshd.service
    ```

  - [x] OPTIONAL: Enable Web Console

    ```bash
    sudo systemctl enable --now cockpit.socket
    ```

    > **Note:** If enabled, the web console will be available on port 9090

## Preparation

- [x] Update `/etc/hostname` with FQDN of the server
- [x] Update `/etc/hosts` with FQDN of the server

    ```bash
    # For example (<IP> <FQDN> <Name>):
    192.168.0.205 soa.local.tomg.me soa
    ```

- [x] Download Software

    RPM files can be downloaded and installed in and admin account home directory (e.g., ~/Downloads) however ZIP files which are intended to be installed as the `oracle` user should be placed somewhere that account has access (e.g., /home/oracle/software).

  - [x] Java 8 JDK

    ```bash
    wget https://javadl.oracle.com/webapps/download/GetFile/1.8.0_321-b07/df5ad55fdd604472a86a45a217032c7d/linux-i586/jdk-8u321-linux-x64.rpm -O ~/Downloads/jdk-8u321-linux-x64.rpm
    ```

  - [x] Download [Oracle Database 21c (21.3) for Linux x86-64](https://www.oracle.com/database/technologies/oracle21c-linux-downloads.html) from the linked OTN page (requires login)
  - [x] Download [SOA Suite Quick Start - Patchset 30188296](https://updates.oracle.com/Orion/PatchDetails/process_form?patch_num=30188296) from the linked page (requires login)
  - [x] Download [Oracle Managed File Transfer - Patchset 30188310](https://updates.oracle.com/Orion/PatchDetails/process_form?patch_num=30188296) from the linked page (requires login)

- [x] Enable X Access

    ```bash
    # Must be done from the server console
    xhost +<workstation IP address>
    ```

- [x] Install JDK

    ```bash
    sudo dnf install jdk-8u321-linux-x64.rpm 
    ```

## Database Install

- [x] Install Oracle Database 21c Prerequisites

    ```bash
    sudo dnf install -y oracle-database-preinstall-21c
    ```

- [x] Set password for 'oracle' user

    ```bash
    sudo passwd oracle
    ```

- [x] Create installation directories

    ```bash
    sudo mkdir -p /u01/app/oracle/product/21.0.0/dbhome_1
    sudo mkdir -p /u01/app/oracle/scripts
    sudo mkdir -p /u02/oradata
    sudo chown -R oracle:oinstall /u01 /u02
    sudo chmod -R 775 /u01 /u02
    ```

- [x] Create environment file

    Make sure ORACLE_HOSTNAME matches the FQDN that you added to `/etc/hosts` and `/etc/hostname` in the [Preparation](#preparation) section above.

    Also check that your JAVA_HOME path is correct based on what was installed earlier.

    ```bash
    # The following must be run as root so do this
    sudo su
    
    # And then do this
    cat > /u01/app/oracle/scripts/setEnv.sh <<EOF
    # Oracle Settings
    export TMP=/tmp
    export TMPDIR=\$TMP

    export ORACLE_HOSTNAME=soa.local.tomg.me
    export ORACLE_UNQNAME=cdb1
    export ORACLE_BASE=/u01/app/oracle
    export ORACLE_HOME=\$ORACLE_BASE/product/21.0.0/dbhome_1
    export ORA_INVENTORY=/u01/app/oraInventory
    export ORACLE_SID=cdb1
    export PDB_NAME=pdb1
    export DATA_DIR=/u02/oradata

    export PATH=/usr/sbin:/usr/local/bin:\$PATH
    export PATH=\$ORACLE_HOME/bin:\$PATH

    export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib
    export CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib

    # Java Settings
    export JAVA_HOME=/usr/java/jdk1.8.0_321-amd64
    EOF
    ```

- [x] Add environment file to 'oracle' user's profile

    ```bash
    # The following must be run as root so do this (if you haven't already)
    sudo su
    
    # And then do this
    echo ". /u01/app/oracle/scripts/setEnv.sh" >> /home/oracle/.bash_profile
    ```

- [x] Create START script

    ```bash
    # The following must be run as root so do this (if you haven't already)
    sudo su
    
    # And then do this
    cat > /u01/app/oracle/scripts/start_all.sh <<EOF
    #!/bin/bash
    . /u01/app/oracle/scripts/setEnv.sh

    export ORAENV_ASK=NO
    . oraenv
    export ORAENV_ASK=YES

    dbstart \$ORACLE_HOME
    EOF
    ```

- [x] Create STOP script

    ```bash
    # The following must be run as root so do this (if you haven't already)
    sudo su
    
    # And then do this
    cat > /u01/app/oracle/scripts/stop_all.sh <<EOF
    #!/bin/bash
    . /u01/app/oracle/scripts/setEnv.sh

    export ORAENV_ASK=NO
    . oraenv
    export ORAENV_ASK=YES

    dbshut \$ORACLE_HOME
    EOF
    ```

- [x] Adjust rights on scripts

    ```bash
    sudo chown -R oracle:oinstall /u01/app/oracle/scripts
    sudo chmod u+x /u01/app/oracle/scripts/*.sh
    ```

- [x] Switch to `oracle` user

    ```bash
    sudo su - oracle
    ```

- [x] Unzip the database installer

    ```bash
    cd $ORACLE_HOME
    unzip -oq /home/oracle/software/LINUX.X64_213000_db_home.zip
    ```

- [x] Run the installer

    This step should be performed by the `oracle` user, but can be done in one of a couple ways.

    **Interactive**

    "Interactive" means using the installer Wizard/GUI. You can either do this from the server console itself (assuming a desktop environment has been installed and you have access to it) or remotely be redirecting to a local X server. (I recommend [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/))

    If you choose to run the installer remotely, ensure that you do the following:

  - [ ] Install a local X server (VcXsrv, Xming) or use an SSH client that has one built in (MobaXTerm)
  - [ ] SSH into the server as the `oracle` user using the **-X** switch to enable X11 forwarding. (Note that logging in a an admin user and performing a `sudo su - oracle` will not work.)

    Then whether from the local or remote console:

  - [ ] Start the interactive installer

    ```bash
    cd $ORACLE_HOME
    ./runInstaller
    ```

    **Silent**

    A "silent" install means starting the installer with all of the required inputs provided as command line switches. This tends to be the less troublesome than the Interactive install assuming you know what the inputs will be ahead of time.

  - [x] Perform "silent" isntall

    ```bash
    cd $ORACLE_HOME
    ./runInstaller -ignorePrereq -waitforcompletion -silent \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp \
    oracle.install.option=INSTALL_DB_SWONLY \
    ORACLE_HOSTNAME=${ORACLE_HOSTNAME} \
    UNIX_GROUP_NAME=oinstall \
    INVENTORY_LOCATION=${ORA_INVENTORY} \
    SELECTED_LANGUAGES=en,en_GB \
    ORACLE_HOME=${ORACLE_HOME} \
    ORACLE_BASE=${ORACLE_BASE} \
    oracle.install.db.InstallEdition=EE \
    oracle.install.db.OSDBA_GROUP=dba \
    oracle.install.db.OSBACKUPDBA_GROUP=dba \
    oracle.install.db.OSDGDBA_GROUP=dba \
    oracle.install.db.OSKMDBA_GROUP=dba \
    oracle.install.db.OSRACDBA_GROUP=dba \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
    DECLINE_SECURITY_UPDATES=true
    ```

- [x] Excute scripts as a root user

    If you switched to the `oracle` user to perform the installation, then `exit` back to the previous account. Otherwise log out and log back in using an admin account. Then do the following:

    ```bash
    sudo /u01/app/oraInventory/orainstRoot.sh
    sudo /u01/app/oracle/product/21.0.0/dbhome_1/root.sh
    ```

- [x] Start the listener

    The following steps should be done as `oracle` so you will need to switch back to that account.

    ```bash
    lsnrctl start
    ```

- [x] Create database

    Like running the Installer previously, creating the database can be done interactively or silent. The same recommendations apply with regards to interactively performing the step remotely -- running an X server, SSH-ing as `oracle` with X11 forwarding enabled, etc.

    **Interactive**

    ```bash
    dbca
    ```

    **Silent**

    ```bash
    dbca -silent -createDatabase \
    -templateName General_Purpose.dbc \
    -gdbname ${ORACLE_SID} -sid ${ORACLE_SID} -responseFile NO_VALUE \
    -characterSet AL32UTF8 \
    -sysPassword SysPassword1 \
    -systemPassword SysPassword1 \
    -createAsContainerDatabase true \
    -numberOfPDBs 1 \
    -pdbName ${PDB_NAME} \
    -pdbAdminPassword PdbPassword1 \
    -databaseType MULTIPURPOSE \
    -memoryMgmtType auto_sga \
    -totalMemory 2000 \
    -storageType FS \
    -datafileDestination "${DATA_DIR}" \
    -redoLogFileSize 50 \
    -emConfiguration NONE \
    -ignorePreReqs
    ```

- [x] Enable restart flag for the instance

    ```bash
    # Change restart flag to Y
    # cdb1:/u01/app/oracle/product/21.0.0/dbhome_1:Y
    nano /etc/oratab
    ```

- [x] Enable Oracle Managed Files (OMF) and ensure PDB starts when the instance starts

    ```bash
    sqlplus / as sysdba <<EOF
    alter system set db_create_file_dest='${DATA_DIR}';
    alter pluggable database ${PDB_NAME} save state;
    exit;
    EOF
    ```

### Install SOA Quick Start

The SOA installation will be done as the `oracle` user. Do **not** run as `root`.

- [x] Set UMASK

    ```bash
    umask 027
    ```

- [x] Unzip Quick Start packages

    Navigate to the folder containing the ZIP files downloaded in the [Preparation](#preparation) section.

    The following file masks should work, but you may need to adjust them or unzip each file individually. There should be a set for the SOA quick start and one for the MFT.

    ```bash
    cd ~/software
    unzip 'p*.zip'
    ```

- [x] Launch the SOA Quick Start installer

    The option to run a Silent install exists, however there was no readily available guidance on what responses are required. This can be fleshed out more in the future. Just know that this will be done interactively.

    ```bash
    JAVA_HOME/bin/java -jar fmw_12.2.1.4.0_soa_quickstart.jar
    ```

    > **Note:** Uncheck the box to "Start JDeveloper" on the Installation Complete screen

### Install MFT

- [x] Unzip MFT for Quick Start package

This should have already been done as part of the preparation for the SOA Quick Start installation.

- [x] Launch the Oracle Managed File Transfer for Quick Start installer

    ```bash
    cd ~/software
    $JAVA_HOME/bin/java -jar fmw_12.2.1.4.0_mft.jar
    ```

    > **Note:** Use the same Oracle Home was used for the SOA Quick Start install

### Configure Compact Domain

- [x] Make sure there are no Java processes running

    ```bash
    ps -ef | grep java
    
    # If any processes exist...
    kill -9 <pid>
    ```

- [x] Create Schemas

    The ORACLE_HOME referenced in the SOA documentation seems to be different than the ORACLE_HOME that was defined during the Database installation so you will probably not want to use the environment variable, but rather move to the full path.

    ```bash
    cd /u01/app/oracle/homes/Middleware/oracle_common/bin
    ./rcu
    ```

    You will select the defaults for most things with the following exceptions:

  - [x] Select Components

    Select "SOA Suite" and "Managed File Transfer"

- [x] Launch the Configuration Wizard

    Take note that the path referenced below is different than the path where we ran the RCU.

    ```bash
    cd /u01/app/oracle/homes/Middleware/oracle_common/common/bin
    export CONFIG_JVM_ARGS=-Dcom.oracle.cie.config.showProfile=true
    ./config.sh
    ```

  - [x] Select "Create a new compact domain"

    > **Note:** If you do not see this option, the issue is with an incorrectly set CONFIG_JVM_ARGS variable.

  - [x] Select "Oracle SOA Suite Reference Configuration" and "Oracle Managed File Transfer" from the list of available templates

## Cleanup

- [x] Start the Administration Server

    ```bash
    cd /u01/app/oracle/homes/Middleware/domains/lab_domain
    ./startWebLogic.sh > ./servers/AdminServer/logs/AdminServer.out 2>&1 &
    ```

    You may monitor the startup process by tailing the output file:

    ```bash
    tail -f ./servers/AdminServer/logs/AdminServer.out
    ```

- [x] Create service to Start/Stop the Database

    Perform the following after a reboot or otherwise when the admin server and database have been shut down.

    ```bash
    sudo touch /lib/systemd/system/dbora.service
    sudo nano /lib/systemd/system/dbora.service
    ```

    Paste the following into the service file:

    ```text
    [Unit]
    Description=The Oracle Database Service
    After=syslog.target network.target

    [Service]
    # systemd ignores PAM limits, so set any necessary limits in the service.
    # Not really a bug, but a feature.
    # https://bugzilla.redhat.com/show_bug.cgi?id=754285
    LimitMEMLOCK=infinity
    LimitNOFILE=65535

    #Type=simple
    # idle: similar to simple, the actual execution of the service binary is delayed
    #       until all jobs are finished, which avoids mixing the status output with shell output of services.
    RemainAfterExit=yes
    User=oracle
    Group=oinstall
    Restart=no
    ExecStart=/bin/bash -c '/home/oracle/scripts/start_all.sh'
    ExecStop=/bin/bash -c '/home/oracle/scripts/stop_all.sh'

    [Install]
    WantedBy=multi-user.target
    ```

    Save the file and then execute the following:

    ```bash
    sudo systemctl daemon-reload
    sudo systemctl start dbora.service
    sudo systemctl enable dbora.service

    # The service should be running. Check it...
    sudo systemctl status dbora.service
    ```

- [x] Enable Notifications

    In the Enterprise Management console (`http://<server IP>:<Server Port>/em/`), open the Target Navigation menu ("tree" icon right below the Oracle logo), expand User Messaging Service, right-click on "usermassagingdriver-email" and select "Email Driver Properties."

    Set the following values:

    | Setting                       | Value                                                          |
    | :---------------------------- | :------------------------------------------------------------- |
    | Capability                    | SEND                                                           |
    | Sender Address                | "Default Sender Address" format as `EMAIL:tomgehrke@gmail.com` |
    | Outgoing Mail Server          | smtp.gmail.com                                                 |
    | Outgoing Mail Server Port     | 465                                                            |
    | Outgoing Mail Server Security | SSL                                                            |
    | Outgoing Username             | tomgehrke@gmail.com                                            |
    | Outgoing Password             | "User Cleartext Password"                                      |

## Home Lab Specific Steps

- [x] Enable "WebLogic Plugin Enabled" Setting

    To allow external access via proxied connections, this setting must be enabled.

  - Log in to the admin console via `http://<server IP>:7001/console`
  - Select the Domain node in the domain structure tree.
  - Make sure the Configuration tab is selected and then click the Web Applications sub-tab.
  - Check "WebLogic Plugin Enabled."

- [x] Set the HTTP request header: WL-Proxy-SSL = true

- [x] Address Certificate Issues if Gmail is used as the Email provider

  - [x] Capture the smtp.gmail.com certificate

    ```bash
    openssl s_client -connect smtp.gmail.com:465 > gmail-smtp-cert.pem 
    ```

    This may run for a while or even never return. You may CTRL-C out at any point as the certificate portion should be captured fairly early on.

  - [x] Edit the text file created to remove any non-cert content
  - [x] Load the certificate into the keystore

    ```bash
    /usr/java/latest/jre/bin/./keytool -import -alias smtp.gmail.com -keystore  /u01/app/oracle/homes/Middleware/wlserver/server/lib/DemoTrust.jks -file ~/gmail-smtp-cert.pem
    ```
