# Install Notes - soa.local.tomg.me

## Environment

| Item              | Value                                |
| :---------------- | :----------------------------------- |
| `oracle` password | y$kcwBUq6B29                         |
| ORACLE_HOSTNAME   | soa.local.tomg.me                    |
| ORACLE_UNIQNAME   | cdb1                                 |
| ORACLE_BASE       | /u01/app/oracle                      |
| ORACLE_HOME       | $ORACLE_BASE/product/21.0.0/dbhome_1 |
| ORA_INVENTORY     | /u01/app/oraInventory                |
| ORACLE_SID        | cdb1                                 |
| PDB_NAME          | pdb1                                 |
| DATA_DIR          | /u02/oradata                         |

## Initial Database Creation

| Item              | Value                                |
| :---------------- | :----------------------------------- |
| sysPassword       | SysPassword1                         |
| systemPassword    | SysPassword1                         |
| pdbAdminPassword  | PdbPassword1                         |
| Database Type     | MULTIPURPOSE                         |

## SOA Quick Start Install

| Item              | Value                                |
| :---------------- | :----------------------------------- |
| Oracle Home       | /u01/app/oracle/homes/Middleware     |

## Schema Creation

| Item              | Value                                |
| :---------------- | :----------------------------------- |
| Host Name         | $ORACLE_HOSTNAME                     |
| Port              | 1521                                 |
| Service Name      | pdb1                                 |
| Username          | sys                                  |
| Password          | [see above]                          |
| Schema Password   | aO94SaIplqo4                         |

## Compact Domain Configuration

| Item                 | Value                                                    |
| :------------------- | :------------------------------------------------------- |
| Domain Location      | /u01/app/oracle/homes/Middleware/domains/lab_domain      |
| Application Location | /u01/app/oracle/homes/Middleware/applications/lab_domain |
| Administrator        | weblogic                                                 |
| Password             | LongWeekend!                                             |
