wget https://raw.githubusercontent.com/kvaps/zabbix-linux-container-template/master/zabbix_container.conf -O /etc/zabbix/zabbix_agentd.conf.d/zabbix_container.conf
service zabbix-agent restart
service zabbix-agent status
